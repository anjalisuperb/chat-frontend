import 'package:chat_roomapp/screens/createsession.dart';
import 'package:chat_roomapp/screens/homepage.dart';
import 'package:chat_roomapp/screens/hostpage.dart';
import 'package:chat_roomapp/screens/registerpage.dart';
import 'package:chat_roomapp/screens/sessions_page.dart';
import 'package:chat_roomapp/screens/userpage.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(ChatApp());
}
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/hostScreen': (context) => HostLogin(),
        '/userScreen': (context) => UserLogin(),
        '/registerScreen': (context) => RegisterPage(),
        '/createSession': (context) => CreateSession(),
        '/sessionScreen': (context) => SessionsPage(),
        
      },
    );
  }
}

