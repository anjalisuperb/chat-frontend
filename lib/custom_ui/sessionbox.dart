import 'package:flutter/material.dart';

class SessionBox extends StatefulWidget {
  const SessionBox({super.key});

  @override
  State<SessionBox> createState() => _SessionBoxState();
}

class _SessionBoxState extends State<SessionBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.all(8),
          height: 300,
          width: double.infinity,
          // color: Colors.lightBlueAccent.shade100,
          child:Card(
            color: Colors.lightBlue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Host name",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                      Text("host id:386h328", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.normal,fontFamily: "Roboto"),),
                      SizedBox(height: 50,),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                          ),
                          child: Text("Join",
                            style: TextStyle(color: Colors.white,fontSize: 20),),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
      );
  }
}
