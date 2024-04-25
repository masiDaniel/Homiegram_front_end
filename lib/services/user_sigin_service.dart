import 'dart:convert';

import 'package:homi_2/models/user_signin.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

String? authToken;
String? firstName;
String? ImageUrl;
int? UserId;

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
    print(
      jsonEncode({
        "email": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final token = userData['token'];
      final first_name = userData['first_name'];
      final userId = userData['id'];
      UserId = userId;
      ImageUrl = userData['profile_pic'];
      authToken = token;
      firstName = first_name;

      return UserRegistration.fromJSon(userData);
    }
  } catch (e) {
    rethrow;
  }
  return null;
}
