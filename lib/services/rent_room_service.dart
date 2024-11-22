// import 'dart:convert';

// import 'package:homi_2/services/user_sigin_service.dart';
// import 'package:http/http.dart' as http;

// const Map<String, String> headers = {
//   "Content-Type": "application/json",
// };

// Future rentRoom(int houseId) async {
//   try {
//     ;
//     final Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Token $authToken',
//     };
//     final response = await http.post(
//       Uri.parse("http://127.0.0.1:8000/houses/assign-tenant/$houseId/"),
//       headers: headers,
//     );

//     if (response.statusCode == 200) {
//       return true;
//     }

//     // Handle a failure response
//     final responseData = jsonDecode(response.body);
//     if (responseData.containsKey('error')) {
//       return responseData['error']; // Display the error message from the API
//     }

//     return "An unexpected error occurred: ${response.statusCode}";
//   } catch (e) {
//     rethrow;
//   }
// }
import 'dart:convert'; // For JSON parsing
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

Future<String?> rentRoom(int houseId) async {
  try {
    // Define headers, including authentication token
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken', // Replace with your actual token
    };

    // Send the POST request to the server
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/houses/assign-tenant/$houseId/"),
      headers: headers,
    );

    // Handle success (status 200)
    if (response.statusCode == 200) {
      return "Room successfully rented!"; // Return success message
    }

    // Handle server errors (status codes 400, 404, etc.)
    final responseData = jsonDecode(response.body);
    if (responseData.containsKey('error')) {
      return responseData['error']; // Return the error message from the server
    }

    // Fallback for unexpected server responses
    return "An unexpected error occurred: ${response.statusCode}";
  } catch (e) {
    // Handle network or unforeseen errors
    return "Something went wrong: ${e.toString()}";
  }
}
