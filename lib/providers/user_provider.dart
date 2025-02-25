import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? authToken;
  int? userId;
  String? userName;
  String? firstName;
  String? lastName;
  String? userEmail;
  String? userType;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    authToken = prefs.getString('authToken');
    userId = prefs.getInt('userId');
    userName = prefs.getString('userName');
    firstName = prefs.getString('firstName');
    lastName = prefs.getString('lastName');
    userEmail = prefs.getString('userEmail');
    userType = prefs.getString('userType');

    notifyListeners(); // Updates all UI components using this data
  }
}
