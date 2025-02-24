import 'dart:convert';
import 'package:homi_2/models/room.dart';
import 'package:homi_2/services/user_sigin_service.dart';

import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};
List<GetRooms> allRooms = [];
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
      allRooms = rooms;
      return rooms;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<GetRooms>> fetchRoomsByHouse(int houseId) async {
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

      // Filter rooms by houseId
      final filteredRooms =
          rooms.where((room) => room.apartmentID == houseId).toList();

      allRooms = rooms;
      return filteredRooms;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<GetRooms> postRoomsByHouse(int houseId, GetRooms newRoom) async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.post(
      Uri.parse('$devUrl/houses/getRooms/'),
      headers: headersWithToken,
      body: jsonEncode(newRoom.tojson()),
    );

    if (response.statusCode == 201) {
      return GetRooms.fromJSon(jsonDecode(response.body));
    } else {
      throw Exception('failed to post new room  ${response.statusCode}');
    }
  } catch (e) {
    rethrow;
  }
}
