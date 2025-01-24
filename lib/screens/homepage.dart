import 'package:chat_roomapp/screens/hostpage.dart';
import 'package:chat_roomapp/screens/userpage.dart';
import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App",
          style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: Colors.blue,
      ),
        backgroundColor: Colors.blue.shade100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/hostScreen');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                  ),
                  child: Text("As a Host",
                    style: TextStyle(color: Colors.white,fontSize: 20),),),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/userScreen');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                  ),
                  child: Text("As a User",
                    style: TextStyle(color: Colors.white,fontSize: 20),),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
