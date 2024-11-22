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
String? phoneNumber;
String? userTypeCurrent;
String azurebaseUrl = 'https://hommiegram.azurewebsites.net';
String devUrl = 'http://127.0.0.1:8000/';

Future fetchUserSignIn(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$devUrl/accounts/login/"),
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
      userTypeCurrent = userData['user_type'];

      return UserRegistration.fromJSon(userData);
    }
  } catch (e) {
    rethrow;
  }
  return null;
}

Future UpdateUserInfo(Map<String, dynamic> updateData) async {
  try {
    // Convert Set to List if necessary
    print("this is the data $updateData");
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };
    final response = await http.patch(
      Uri.parse("$devUrl/accounts/user/update/"),
      headers: headersWithToken,
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {
    rethrow;
  }
  return null;
}
