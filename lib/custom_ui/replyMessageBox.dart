import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ReceiveMessageCard extends StatelessWidget {
  const ReceiveMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width -150,),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          color: Colors.white,
          child:  Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                child: Text("Hey! How are you ",
                  style: TextStyle(fontSize: 16,color: Colors.black,fontFamily: "Roboto"),),),
              Positioned(
                bottom: 2,
                right: 20,
                child: Text(formattedTime,
                  style: TextStyle(fontSize: 15,color: Colors.grey[300]),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
