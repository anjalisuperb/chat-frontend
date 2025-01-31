import 'package:chat_roomapp/screens/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apimodel/getAllUsers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateSession extends StatefulWidget {
  final AllUsers users;
  final AllSessions sessions;
  const CreateSession({super.key,required this.sessions,required this.users});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  bool isLoading = false;
  String host_id = "";
  @override
  void initState() {
    super.initState();
    loadhostid();
  }
  Future<void> loadhostid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      host_id = prefs.getString("id") ?? "";
      print("Id: $host_id");
    });
  }

  Future<void> onCreateClick() async {
    if (host_id.isEmpty) {
      print("Host ID is empty");
      return;
    }

    print("Creating session with Host ID: $host_id");
    final url = Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/chatSession/newSession");
    final body = jsonEncode({
      'hostId': host_id,
      'participants': [],
    });
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session created successfully!')),
        );
        var responseData = jsonDecode(response.body);
        var session = responseData['session'];
        print("Session: $session");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('hostid', session['hostId']);
        prefs.setString('participants', jsonEncode(session['participants']));
        prefs.setString('status', session['status']);
        prefs.setString('sessionid', session['_id']);
        prefs.setString('createdAt', session['createdAt']);
        prefs.setString('updatedAt', session['updatedAt']);
        var sessionId=prefs.getString("sessionid");
        print("Session Id: $sessionId");
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(sessions: widget.sessions, users: widget.users,),));
      }
      else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Internal Server Error`: Failed to create chat session')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    }catch(e){
      print("Error show in create session: $e");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: Text("Create Session page",
          style: TextStyle(color: Colors.white,fontSize: 20),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SizedBox(
          height: 50,
          width: 200,
          child: ElevatedButton(
            onPressed: (){
              onCreateClick();
              // Navigator.pushNamed(context, '/sessionScreen');

            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
            ),
            child: Text("Create",
              style: TextStyle(color: Colors.white,fontSize: 20),),
          ),
        ),
      ),
    );
  }
}
