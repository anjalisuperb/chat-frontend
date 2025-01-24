import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class SendMessageCard extends StatelessWidget {
  final String message;
  const SendMessageCard({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width -150,
          minWidth: 150,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          color: Colors.teal[300],
          child:  Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                child: Text(message,
                  style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "Roboto"),),),
              Positioned(
                bottom: 2,
                right: 5,
                child: Row(
                  children: [
                    Text(formattedTime,
                      style: TextStyle(fontSize: 15,color: Colors.grey[300]),),
                    SizedBox(width: 5,),
                    Icon(Icons.done_all,color: Colors.white,size: 20,),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
