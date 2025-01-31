import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  bool isLoading=false;
  Future<void> onSubmit(String host_id) async {
    print("Host id: $host_id");
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse('https://scalable-chat-app-qcq3.onrender.com/api/auth/login');
      final body = jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      });

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        // print(response.body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logged in successfully!')),
          );
          var responseData = jsonDecode(response.body);
          var user = responseData['user'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', user['_id']);
          prefs.setString('username', user['username']);
          prefs.setString('email', user['email']);
          prefs.setString('role', user['role']);
          prefs.setString('status', user['status']);
          var storeId = prefs.getString("id");
          var storeUsername = prefs.getString("username");
          var storeEmail = prefs.getString("email");
          var storeRole = prefs.getString("role");
          var storeStatus = prefs.getString("status");
          print("Username:$storeUsername");
          Future.delayed(Duration(milliseconds: 100), () {
            Navigator.pushNamed(context, '/createSession');
          });
        }
        else if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid email or password.')),
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please check your connection.')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? _validateEmail(value){
    if(value!.isEmpty){
      return "please enter email";
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
    return Center(
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
                hintText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validatePassword,
              controller: passwordController,
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
                onPressed: isLoading ? null : () {
                  onSubmit("host_id");
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                ),
                child: isLoading ? CircularProgressIndicator(color: Colors.white,):Text("Login",
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
    );
  }
}