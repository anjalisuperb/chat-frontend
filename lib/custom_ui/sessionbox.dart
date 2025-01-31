import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_roomapp/apimodel/getAllUsers.dart';
import 'package:flutter/material.dart';
import '../screens/chatPage.dart';

class SessionBox extends StatefulWidget {
  final AllUsers users;
  final AllSessions sessions;
  const SessionBox({super.key,required this.sessions,required this.users});

  @override
  State<SessionBox> createState() => _SessionBoxState();
}

class _SessionBoxState extends State<SessionBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      height: 300,
      width: double.infinity,
      child: Card(
        color: Colors.lightBlue.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("${widget.sessions.username}", style: TextStyle(fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     fontFamily: "Roboto"),),
              Text("Session Id: ${widget.sessions.id}", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Roboto"),),
              Text("Host Id: ${widget.sessions.hostid}", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Roboto"),),
              SizedBox(height: 50,),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    joinSession(widget.sessions.id);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                  ),
                  child: Text("Join",
                    style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> joinSession(String session_id) async {
    // print(session_id);
    final url = Uri.parse(
        'https://scalable-chat-app-qcq3.onrender.com/api/chatSession/${session_id}/join');
    final body = jsonEncode({
      'userId': widget.sessions.hostid,
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Joined session successfully!')),
        // );

        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(sessions: widget.sessions, users: widget.users,),));
      }
      else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join session!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    }
    catch (e) {
      print("Error throw: $e");
    }
  }
}
