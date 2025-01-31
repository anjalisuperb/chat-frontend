import 'package:chat_roomapp/socketmodel/socketconnection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apimodel/getAllUsers.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../pages/userrole.dart';

class ChatPage extends StatefulWidget {
  final AllSessions sessions;
  final AllUsers users;

  const ChatPage({super.key, required this.sessions, required this.users});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // late ScrollController scrollController;
  late SocketService socketService;
  bool showemoji = false;
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  List<PreviousMessages> messages = [];
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
      // scrollController = ScrollController();
      socketService=SocketService();
      socketService.initSocket();
      socketListener();
    });
    fetchPreviousMessages(widget.sessions.id);
    loadUsername();
    loadid();
    fetchUserRole();
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
    if(role=="host"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        id = prefs.getString("sessionid") ?? "";
      });
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        id = prefs.getString("id") ?? "";
      });
    }
  }

  Future<void> fetchPreviousMessages(String sessionId) async {
    final url = Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/message/$sessionId");

    try {
      final response = await http.get(url);
      print("Full API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic>? jsonData = convert.jsonDecode(response.body);

        if (jsonData == null) {
          print("Error: API returned null JSON.");
          return;
        }

        if (jsonData.containsKey('messages') && jsonData['messages'] is List) {
          setState(() {
            messages = (jsonData['messages'] as List)
                .map((msg) {
              try {
                return PreviousMessages.fromJson(msg);
              } catch (e) {
                print("Error parsing message: $e");
                return null;
              }
            })
                .whereType<PreviousMessages>()
                .where((msg) => role != "host" || msg.senderId != id)
                .toList();
          });
        } else {
          print("Error: 'messages' key not found or is not a list.");
        }
      } else {
        print("Failed to load messages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }


  // void scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController.hasClients) {
  //       scrollController.animateTo(
  //         scrollController.position.maxScrollExtent,
  //         duration: Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  void socketListener() {
    socketService.socket.on('message', (data) {
      print("Socket Data: $data");
      if (mounted) {
        setState(() {
          messages.add(PreviousMessages(
            senderId: data['senderId'],
            senderName: data['senderName'],
            content: data['content'],
            createdAt: data['createdAt'],
          ));
        });
        // scrollToBottom();
      }
    });
    socketService.socket.on('userjoined',(data){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data['username']} joined the chat")));
      }
    });
    socketService.socket.on('userleft',(data){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data['username']} left the chat")));
      }
    });
    socketService.joinChatSession(widget.sessions.id);
  }
  void dispose() {
    // scrollController.dispose();
    socketService.leaveChatSession(widget.sessions.id);
    super.dispose();
  }

  void sendMessage() async {
    if (controller.text.trim().isEmpty) return;
    final messageContent = controller.text.trim();
    socketService.sendMessage(widget.sessions.id, username, id, messageContent);
    final url = Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/message/${widget.sessions.id}");
    final body = convert.jsonEncode({
      'senderId': id,
      'content': controller.text.trim(),
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      // print("Send Message Response: ${response.body}");

      if (response.statusCode == 201) {
        setState(() {
          messages.add(PreviousMessages(
            content: controller.text.trim(),
            senderId: id,
            senderName: username,
            createdAt: DateTime.now().toIso8601String(),
          ));
        });
        // scrollToBottom();
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
                // controller: scrollController,
                padding: EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  bool isCurrentUser = message.senderId == id;

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
                            message.senderName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            message.content,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formatDateTime(message.createdAt),
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
            if(role!="host")
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
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(border: InputBorder.none, hintText: "Write a message"),
                    ),
                  ),

                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(Icons.send,color: Colors.blue,),
                    // child: Text(
                    //   "Send",
                    //   style: TextStyle(color: Colors.teal[300], fontSize: 14, fontWeight: FontWeight.bold),
                    // ),
                  ),
                ],
              ),
            ),

            if(role!="host")
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
}
