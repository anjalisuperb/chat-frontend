import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketEvents {
  static const String CONNECTION = "connection";
  static const String DISCONNECT = "disconnect";
  static const String JOIN_ROOM = "join-room";
  static const String LEAVE_ROOM = "leave-room";
  static const String SEND_MESSAGE = "send-message";
  static const String RECEIVE_MESSAGE = "receive-message";
  static const String NEW_MESSAGE = "new-message";
  static const String GET_MESSAGES = "get-messages";
  static const String GET_SESSIONS = "get-sessions";
  static const String CREATE_SESSION = "create-session";
}

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void initSocket() {
    socket = IO.io('https://scalable-chat-app-qcq3.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on(SocketEvents.CONNECTION, (_) {
      print('Socket connected');
    });

    socket.on(SocketEvents.DISCONNECT, (_) {
      print('Socket disconnected');
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });
  }

  void joinChatSession(String sessionId) {
    socket.emit(SocketEvents.JOIN_ROOM, {'sessionId': sessionId});
  }

  void leaveChatSession(String sessionId) {
    socket.emit(SocketEvents.LEAVE_ROOM, {'sessionId': sessionId});
  }

  void sendMessage(String sessionId, String senderId, String content, String senderName) {
    socket.emit(SocketEvents.SEND_MESSAGE, {
      'sessionId': sessionId,
      'senderId': senderId,
      'content': content,
      'username': senderName,
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  void dispose() {
    socket.dispose();
  }
}