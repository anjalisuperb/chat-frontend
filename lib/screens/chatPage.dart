import 'package:chat_roomapp/apimodel/PreviousMessageResponseModel.dart';
import 'package:chat_roomapp/socketmodel/socketconnection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apimodel/getAllUsers.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../pages/userrole.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final AllSessions sessions;
  final AllUsers users;

  const ChatPage({super.key, required this.sessions, required this.users});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // late IO.Socket socket;
  final SocketService socketService=SocketService();
  // List<Map<String, dynamic>> messages = [];

  bool showemoji = false;
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  List<Messages> messages = [];
  String username = "";
  String id = "";
  String? role;


  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showemoji = false;
        });
      }
    });
    // connectSocket();
    setupSocket();
    fetchPreviousMessages(widget.sessions.id);
    loadUsername();
    loadid();
    fetchUserRole();
  }
  void setupSocket(){
    socketService.initSocket();
    if(id.isNotEmpty){socketService.addNewUser(id);}
    socketService.joinChatSession(widget.sessions.id);
    socketService.listenToMessages((message){
      if(mounted){
        setState(() {
          //messages.add(message);
        });
      }
    });
  }

  Future<void> fetchUserRole() async {
    String? fetchedRole = await getUserRole();
    setState(() {
      role = fetchedRole;
    });
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? "";
    });
  }

  Future<void> loadid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = role == "host" ? prefs.getString("sessionid") ?? "" : prefs.getString("id") ?? "";
    });
  }

  Future<void> fetchPreviousMessages(String sessionId) async {
    final url = Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/message/$sessionId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = convert.jsonDecode(response.body);
        var model = PreviousMessageModel.fromJson(jsonData);
        setState(() {
          messages = model.messages ?? [];
        });

      } else {
        print("Failed to load messages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }


  void sendMessage() async {
    if (controller.text.trim().isEmpty) return;
    final messageContent = controller.text.trim();
    // socketService.sendMessage(widget.sessions.id, id, messageContent, username);
    final url = Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/message/${widget.sessions.id}");
    final body = convert.jsonEncode({
      'senderId': id,
      'content': messageContent,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> messageData = {
          'sender': {
            'id': id,
            'username': username,
          },
          'content': messageContent,
          'createdAt': DateTime.now().toIso8601String(),
        };
        setState(() {
          var message = Messages(
            content: messageData['content'] ?? "",
            sender: Sender(id: id, name: username),
            createdAt: DateTime.now().toIso8601String(),
          );
          print(message.content);
          setState(() {
            messages.add(message);
          });
        });

        // Send through socket for real-time update
        socketService.sendMessage(
          sessionId: widget.sessions.id,
          message: messageData,
        );
        controller.clear();
      } else if (response.statusCode == 404) {
        showSnackbar("Chat session not found!");
      } else {
        showSnackbar("Something went wrong. Please try again.");
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: Text("Session ID: ${widget.sessions.id}", style: TextStyle(fontSize: 18)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (showemoji) {
            setState(() => showemoji = false);
            return false;
          } else {
            return true;
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser = message.sender?.id == id;

                  return Align(
                    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.sender?.name ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            message.content ?? "",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formatDateTime(message.createdAt ?? ""),
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (role != "host")
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        focusNode.unfocus();
                        setState(() => showemoji = !showemoji);
                      },
                      icon: Icon(Icons.emoji_emotions_outlined),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        onTap: (){
                          focusNode.requestFocus();
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(border: InputBorder.none, hintText: "Write a message"),
                      ),
                    ),
                    IconButton(
                      onPressed: sendMessage,
                      icon: Icon(Icons.send, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            if (role != "host")
              Offstage(
                offstage: !showemoji,
                child: SizedBox(height: 250, child: emojiSelect()),
              ),
          ],
        ),
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      key: Key('emoji_picker'),
      onEmojiSelected: (Category? category, Emoji emoji) {
        if (!focusNode.hasFocus) {
          FocusScope.of(context).requestFocus(focusNode);
        }

        setState(() {
          controller.text += emoji.emoji;
          controller.selection = TextSelection.collapsed(offset: controller.text.length);
        });
      },
    );
  }

  String formatDateTime(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate).toLocal();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }
  void dispose() {
    socketService.leaveChatSession(widget.sessions.id);
    socketService.dispose();
    super.dispose();
  }
}