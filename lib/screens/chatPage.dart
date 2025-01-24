
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';


// void main(){runApp(ChatPage());}
class ChatPage extends StatefulWidget {
  final AllUsers users;
  const ChatPage({super.key, required this.users});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool showemoji = false;
  FocusNode focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  List<String> messages = [];

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
  }

  void sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add(_controller.text.trim());
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green[50],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 70,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.grey, size: 24),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.only(right: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30, color: Colors.purple),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "anjali",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WillPopScope(
            onWillPop: () {
              if (showemoji) {
                setState(() {
                  showemoji = false;
                });
              } else {
                Navigator.pop(context);
              }
              return Future.value(false);
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SendMessageCard(
                            message: messages[index],
                          ),
                          ReceiveMessageCard(),
                        ],
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: _controller,
                            focusNode: focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write message",
                              prefixIcon: IconButton(
                                onPressed: () {
                                  focusNode.unfocus();
                                  setState(() {
                                    showemoji = !showemoji;
                                  });
                                },
                                icon: Icon(Icons.emoji_emotions_outlined),
                              ),
                              suffixIcon: TextButton(
                                onPressed: sendMessage,
                                child: Text(
                                  "Send",
                                  style: TextStyle(
                                    color: Colors.teal[300],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        showemoji ? emojiSelect() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      key: Key('emoji_picker'),
      onEmojiSelected: (Category? category, Emoji emoji) {
        setState(() {
          _controller.text = _controller.text + emoji.emoji;
          _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length)
          );

        });
      },
    );
  }
}


