import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // Keys
  static const String _keyAuthToken = 'authToken';
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyFirstName = 'firstName';
  static const String _keyLastName = 'lastName';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserType = 'userType';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  // static const String _keyProfilePic = 'profilePicture';

  // Save data example:
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, userData['token']);
    await prefs.setInt(_keyUserId, userData['id']);
    await prefs.setString(_keyUserName, userData['username']);
    await prefs.setString(_keyFirstName, userData['first_name']);
    await prefs.setString(_keyLastName, userData['last_name']);
    await prefs.setString(_keyUserEmail, userData['email']);
    await prefs.setString(_keyUserType, userData['user_type']);
    // await prefs.setString(_keyProfilePic, userData['profile_pic']);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Getters to retrieve stored data
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName);
  }

  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
