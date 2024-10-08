import 'dart:convert';

import 'package:homi_2/models/user_signin.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

String? authToken;
String? firstName;
String? imageUrl;
int? userId;
String? lastName;
String? userName;
DateTime? dateJoined;
String? userEmail;
int? idNumber;
int? phoneNumber;

Future fetchUserSignIn(String username, String password) async {
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
      final first_name = userData['first_name'];
      final currentUserId = userData['id'];

      userId = currentUserId;
      imageUrl = userData['profile_pic'];
      authToken = token;
      firstName = first_name;
      lastName = userData['last_name'];
      userName = userData['username'];
      userEmail = userData['email'];
      idNumber = userData['id_number'];
      phoneNumber = userData['phone_number'];

      return UserRegistration.fromJSon(userData);
    }
  } catch (e) {
    rethrow;
  }
  return null;
}
