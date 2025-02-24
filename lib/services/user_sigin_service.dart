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

    if (response.statusCode == 200) {
      print("we are here 200");
      print("Response for Wendy: ${response.body}");
      // print("Response for Daniel: ${response.body}");
      // final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(response.body);
      await UserPreferences.saveUserData(userData);
      print("User data decoded: $userData");
      final registration = UserRegistration.fromJSon(userData);
      print("Parsed UserRegistration: $registration");
      String? token = await UserPreferences.getAuthToken();
      // final token = userData['token'];
      final currentUserId = userData['id'];
      // await prefs.setString('authToken', token);

      // handle this in a better manner.
      userId = currentUserId;
      imageUrl = userData['profile_pic'];
      authToken = token;
      firstName = userData['first_name'];
      lastName = userData['last_name'];
      userName = userData['username'];
      userEmail = userData['email'];
      idNumber = userData['id_number'];
      phoneNumber = userData['phone_number'];
      userTypeCurrent = await UserPreferences.getUserType();

      final userDataShared = json.decode(response.body);
      final tokenData = userData['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', tokenData);
      await prefs.setInt('userId', userDataShared['id']);
      await prefs.setString('userName', userDataShared['username']);
      await prefs.setString('firstName', userDataShared['first_name']);
      await prefs.setString('lastName', userDataShared['last_name']);
      await prefs.setString('userEmail', userDataShared['email']);
      await prefs.setString('userType', userDataShared['user_type']);
      await prefs.setBool('isLoggedIn', true); // Set login status to true
      // return UserRegistration.fromJSon(userData);

      print("we are here inside 200");
      print("this is the data ${UserRegistration.fromJSon(userData)}");

      return UserRegistration.fromJSon(userData);
    }
  } catch (e) {
    log("Error during sign-in: $e");
    return null; // or return a specific error response
  }
  return null;
}

Future updateUserInfo(Map<String, dynamic> updateData) async {
  try {
    // Convert Set to List if necessary
    log("this is the data $updateData");
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
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
