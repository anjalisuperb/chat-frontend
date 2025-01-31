import 'package:chat_roomapp/pages/loginpage.dart';
import 'package:chat_roomapp/pages/userrole.dart';
import 'package:flutter/material.dart';

class HostLogin extends StatefulWidget {
  const HostLogin({super.key});

  @override
  State<HostLogin> createState() => _HostLoginState();
}

class _HostLoginState extends State<HostLogin> {
  // final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  // var emailController=TextEditingController();
  // var passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    saveUserRole('host');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: Text("Host Page",
          style: TextStyle(color: Colors.white,fontSize: 20),),
        backgroundColor: Colors.blue,
      ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: LoginPage(),
        ),
    );
  }
}
