import 'dart:convert';
import 'package:homi_2/models/room.dart';
import 'package:homi_2/services/user_sigin_service.dart';

import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};
List<GetRooms> AllRooms = [];
String? houseId;

// /this is used in the home_page class(commented out) and the house list page

Future<List<GetRooms>> fetchRooms() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(Uri.parse('$devUrl/houses/getRooms/'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> roomData = json.decode(response.body);

      final List<GetRooms> rooms =
          roomData.map((json) => GetRooms.fromJSon(json)).toList();
      AllRooms = rooms;
      return rooms;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}
