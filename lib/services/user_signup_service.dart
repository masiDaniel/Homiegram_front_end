import 'dart:convert';
import 'package:homi_2/models/user_signup.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

Future<UserSignUp?> fetchUserSignUp(
    String first_name, String last_name, String email, String password) async {
  try {
    final response =
        await http.post(Uri.parse("http://127.0.0.1:8000/accounts/signup/"),
            headers: headers,
            body: jsonEncode({
              "first_name": first_name,
              "last_name": last_name,
              "email": email,
              "password": password,
            }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('message') &&
          jsonResponse["message"] == "User successfully registered") {
        return UserSignUp.fromJSon(jsonResponse);
      } else {
        throw Exception("server returned status: ${response.statusCode}");
      }
    } else {
      throw Exception("request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    rethrow;
  }
}
