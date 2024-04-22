// import 'dart:convert';

// import 'package:homi_2/models/user_signin.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

Future logoutUser() async {
  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/accounts/logout/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {
    rethrow;
  }
  return false;
}
