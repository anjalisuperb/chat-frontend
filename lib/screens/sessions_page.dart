import 'package:chat_roomapp/custom_ui/sessionbox.dart';
import 'package:chat_roomapp/pages/userrole.dart';
import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {

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
            itemCount: 10,
            itemBuilder: (context,index){
              return SessionBox();
            }),
    );
  }
}
