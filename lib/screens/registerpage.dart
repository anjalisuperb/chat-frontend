import 'package:chat_roomapp/pages/userrole.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? role;
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    String? fetchedRole = await getUserRole();
    setState(() {
      role = fetchedRole;
    });
  }
  void onSubmit() async{
    if(_formkey.currentState!.validate()){
      ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
          const SnackBar(content: Text("register successfully"))
      );
    }
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text.toString());
    prefs.setString('email', emailController.text.toString());
    prefs.setString("password", passwordController.text.toString());

    getUserRole();
    if(role=='user'){
      Navigator.pushNamed(context, '/userScreen');
    }
    else if(role=='host'){
      Navigator.pushReplacementNamed(context, '/hostScreen');
    }
    else{
      print("No role found");
    }
  }
  String? _validatename(value){
    if(value!.isEmpty){
      return "please enter your name";
    }
    return null;
  }
  String? _validateUsername(value){
    if(value!.isEmpty){
      return "Please enter username";
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

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        title: Text("Register Page",
          style: TextStyle(color: Colors.white,fontSize: 20),),
        backgroundColor: Colors.blue,
      ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validatename,
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateUsername,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email id",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10,),
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
                      onPressed: (){
                        onSubmit();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                      ),
                      child: Text("Submit",
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
