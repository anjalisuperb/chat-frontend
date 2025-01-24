import 'package:chat_roomapp/pages/userrole.dart';
import 'package:chat_roomapp/screens/registerpage.dart';
import 'package:chat_roomapp/screens/sessions_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
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
    saveUserRole('user');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: Text("User Page",
          style: TextStyle(color: Colors.white,fontSize: 20),),
        backgroundColor: Colors.blue,
      ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateEmail,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email id",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validatePassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 40,),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: (){
                        onSubmit();
                        onclick();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SessionsPage()));
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                      ),
                      child: Text("Login",
                        style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("If you don't have an account then"),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/registerScreen');
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                      ),
                      child: Text("Register",
                        style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
    );
  }
}
