import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserRole(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userRole', role);
}

Future<String?> getUserRole() async{
  final prefs=await SharedPreferences.getInstance();
  return prefs.getString('userRole');
}

Future<void> clearUserRole() async{
  final prefs=await SharedPreferences.getInstance();
  await prefs.remove('userRole');
}

// void checkUserRole(BuildContext context) async{
//   final role=await getUserRole();
//   if (role == 'host') {
//     Navigator.pushReplacementNamed(context, '/registerScreen');
//   }
//   else if(role=='user'){
//     Navigator.pushReplacementNamed(context, '/SessionsPage');
//   }
//   else{
//     print("No role found");
//   }
// }
