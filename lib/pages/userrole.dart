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





