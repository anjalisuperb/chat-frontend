import 'package:chat_roomapp/apimodel/getAllUsers.dart';
import 'package:chat_roomapp/custom_ui/sessionbox.dart';
import 'package:chat_roomapp/pages/userrole.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<AllSessions> sessions=[];
  List<AllUsers> users=[];
  @override
  void initState() {
    super.initState();
    fetchAllUsers();
    fetchAllSessions();
  }

  Future<void> fetchAllUsers() async{
    final response = await http.get(Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/user/"));

    if (response.statusCode == 200) {
      // print(response.body);
      Map<String, dynamic> jsonData = convert.json.decode(response.body);
      if(jsonData.containsKey("users")){
        List<dynamic> userlist=jsonData["users"];
      setState(() {
        users.clear();
        users.addAll(userlist.map((data) => AllUsers.fromJson(data)));
      });}
      else{
        print("Error: 'users' key not found in response");
      }
    } else {
      print("Error in fetching data!");
    }
  }

  Future<void> fetchAllSessions() async{
    final response = await http.get(Uri.parse("https://scalable-chat-app-qcq3.onrender.com/api/chatSession/"));
    if (response.statusCode == 200) {
      // print(response.body);
      Map<String,dynamic> jsonData = convert.json.decode(response.body);
      if(jsonData.containsKey("sessions")){
        List<dynamic> sessionList=jsonData["sessions"];
        setState(() {
        sessions.clear();
        sessions.addAll(sessionList.map((data) => AllSessions.fromJson(data)));
      });}
      else{
        print("Error: 'sessions' key not found in response");
      }
    }else {
      print("Error in fetching data! Status Code: ${response.statusCode}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          leading: InkWell(
            onTap: () {
              clearUserRole();
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          title: Text("Session Page",
            style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: Colors.blue,
        ),
          body: ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return SessionBox(sessions: sessions[index],users: index < users.length ? users[index] : AllUsers.defaultUser()
              );
            },
          ),
    );
  }
}
