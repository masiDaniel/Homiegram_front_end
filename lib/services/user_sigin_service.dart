import 'dart:convert';
import 'dart:developer';
import 'package:homi_2/models/user_signin.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:http/http.dart' as http;

///
/// the use of global variables is not the best approach,
/// i will change this to use provider (state management) to make the code,
/// easier to test and maintain
///

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

String productionUrl =
    'https://hommiegram.azurewebsites.net'; // this will be deleted.
String devUrl = 'http://192.168.0.106:8000/';

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

      // how to handle saving of data well
      await UserPreferences.saveUserData(userData);

      return UserRegistration.fromJSon(userData);
    }
  } catch (e) {
    log("Error during sign-in: $e");
    return null; // or return a specific error response
  }
  return null;
}

Future updateUserInfo(Map<String, dynamic> updateData) async {
  String? token = await UserPreferences.getAuthToken();
  try {
    // Convert Set to List if necessary
    log("this is the data $updateData");
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };
    final response = await http
        .patch(
          Uri.parse("$devUrl/accounts/user/update/"),
          headers: headersWithToken,
          body: jsonEncode(updateData),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {
    rethrow;
  }
  return null;
}
