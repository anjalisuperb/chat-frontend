import 'package:chat_roomapp/pages/loginpage.dart';
import 'package:chat_roomapp/pages/userrole.dart';
import 'package:chat_roomapp/screens/createsession.dart';
import 'package:chat_roomapp/screens/registerpage.dart';
import 'package:chat_roomapp/screens/sessions_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HostLogin extends StatefulWidget {
  const HostLogin({super.key});

  @override
  State<HostLogin> createState() => _HostLoginState();
}

class _HostLoginState extends State<HostLogin> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  void onclick() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text.toString());
    prefs.setString("password", passwordController.text.toString());
  }
  void onSubmit(){
    if(_formkey.currentState!.validate()){
      ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
          const SnackBar(content: Text("login successfully"))
      );
    }
  }
  String? _validateEmail(value){
    if(value!.isEmpty){
      return "please enter username";
    }
    return null;
  }
  String? _validatePassword(value){
    if(value!.isEmpty){
      return "please enter password";
    }
    return null;
  }
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
