import 'dart:convert';

import 'package:homi_2/models/user_signin.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

String? authToken;

Future fetchUserRegistration(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/accounts/login/"),
      headers: headers,
      body: jsonEncode({
        "email": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final token = userData['token'];
      authToken = token;
      print(authToken);
      return UserRegistration.fromJSon(userData);
    }
  } catch (e) {
    rethrow;
  }
  return null;
}
