import 'dart:convert';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

Future<String?> rentRoom(int houseId) async {
  try {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };

    final response = await http.post(
      Uri.parse("$devUrl/houses/assign-tenant/$houseId/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return "Room successfully rented!";
    }

    final responseData = jsonDecode(response.body);
    if (responseData.containsKey('error')) {
      return responseData['error'];
    }

    return "An unexpected error occurred: ${response.statusCode}";
  } catch (e) {
    return "Something went wrong: ${e.toString()}";
  }
}
