import 'dart:convert';
import 'dart:developer';
import 'package:homi_2/models/user_signin.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

///
/// the use of global variables is not the best approach,
/// i will change this to use provider (state management) to make the code,
/// easier to test and maintain
///

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
String productionUrl =
    'https://hommiegram.azurewebsites.net'; // this will be deleted.
String devUrl = 'http://192.168.2.127:8000/';

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

    print(' we are just about to hit gold');

    if (response.statusCode == 200) {
      print(' we have hit gold');
      print('Raw response body: ${response.body}');
      final userData = json.decode(response.body);
      print('Decoded response: $userData');

      // how to handle saving of data well
      await UserPreferences.saveUserData(userData);

      imageUrl = userData['profile_pic'];
      firstName = userData['first_name'];
      lastName = userData['last_name'];
      userName = userData['username'];
      userEmail = userData['email'];
      idNumber = userData['id_number'];
      phoneNumber = userData['phone_number'];

      print('Raw response body second : ${response.body}');

      final userDataShared = json.decode(response.body);
      print('Decoded response: $userDataShared');

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', userDataShared['token']);
        await prefs.setInt('userId', userDataShared['id']);
        await prefs.setString('userName', userDataShared['username']);
        await prefs.setString('firstName', userDataShared['first_name']);
        await prefs.setString('lastName', userDataShared['last_name']);
        await prefs.setString('userEmail', userDataShared['email']);
        await prefs.setString('userType', userDataShared['user_type']);
        await prefs.setBool('isLoggedIn', true);
        print('Preferences saved successfully!');
      } catch (e) {
        print('Error saving preferences: $e');
      }
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
