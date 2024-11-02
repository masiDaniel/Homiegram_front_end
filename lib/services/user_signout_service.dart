// import 'dart:convert';

// import 'package:homi_2/models/user_signin.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};
Future logoutUser() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };
    print("this is the token ${authToken}");
    final response = await http.post(
      Uri.parse("$azurebaseUrl/accounts/logout/"),
      headers: headersWithToken,
    );

    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {
    rethrow;
  }
  return false;
}
