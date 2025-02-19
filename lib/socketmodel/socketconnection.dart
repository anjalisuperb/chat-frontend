import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketEvents {
  static String CONNECTION = "connection";
  static String DISCONNECT = "disconnect";
  static String JOIN_ROOM = "join-room";
  static String LEAVE_ROOM = "leave-room";
  static String NEW_USER_ADD = "new-user-add";
  static String GET_USERS = "get-users";
  static String SEND_MESSAGE = "send-message";
  static String RECEIVE_MESSAGE = "receive-message";
  static String NEW_MESSAGE = "new-message";
}

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  List<Map<String, dynamic>> activeUsers = [];

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void initSocket() {
    socket = IO.io('https://scalable-chat-app-qcq3.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionDelay': 1000,
      'reconnectionAttempts': 5
    });

    socket.connect();

    // Basic socket event listeners
    socket.onConnect((_) {
      print('Socket Connected: ${socket.id}');
    });

    socket.onDisconnect((_) {
      print('Socket Disconnected');
    });

    socket.on('error', (error) {
      print('Socket Error: $error');
    });

    // Listen for active users updates
    socket.on(SocketEvents.GET_USERS, (users) {
      activeUsers = List<Map<String, dynamic>>.from(users);
      print('Active Users Updated: $activeUsers');
    });
  }

  void addNewUser(String userId) {
    socket.emit(SocketEvents.NEW_USER_ADD, userId);
  }

  void joinChatSession(String sessionId) {
    socket.emit(SocketEvents.JOIN_ROOM, {'sessionId': sessionId});
  }

  void leaveChatSession(String sessionId) {
    socket.emit(SocketEvents.LEAVE_ROOM, {'sessionId': sessionId});
  }

  void sendMessage({
    String? receiverId,
    String? sessionId,
    required Map<String, dynamic> message,
  }) {
    socket.emit(SocketEvents.SEND_MESSAGE, {
      'receiverId': receiverId,
      'sessionId': sessionId,
      'message': message,
    });
  }

  void listenToMessages(Function(Map<String, dynamic>) onMessageReceived) {
    // Listen for both direct messages and group messages
    socket.on(SocketEvents.RECEIVE_MESSAGE, (data) => onMessageReceived(data));
    socket.on(SocketEvents.NEW_MESSAGE, (data) => onMessageReceived(data));
  }

  void disconnect() {
    socket.disconnect();
  }

  void dispose() {
    socket.dispose();
  }

  bool get isConnected => socket.connected;
}