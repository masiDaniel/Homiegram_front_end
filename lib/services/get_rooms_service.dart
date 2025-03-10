import 'dart:convert';
import 'package:homi_2/models/room.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';

import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};
List<GetRooms> allRooms = [];
String? houseId;

// /this is used in the home_page class(commented out) and the house list page

Future<List<GetRooms>> fetchRooms() async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.get(Uri.parse('$devUrl/houses/getRooms/'),
        headers: headersWithToken);
    print('we are getting here 1');
    if (response.statusCode == 200) {
      print('we are getting here 2');
      final List<dynamic> roomData = json.decode(response.body);

      // final List<GetRooms> rooms =
      //     roomData.map((json) => GetRooms.fromJSon(json)).toList();
      // allRooms = rooms;
      // print('respose body get roomms : $allRooms');

      try {
        print("Raw roomData before parsing: $roomData");

        final List<GetRooms> rooms = roomData.map((json) {
          print("Processing room: $json"); // Print each room before parsing
          return GetRooms.fromJSon(json);
        }).toList();

        allRooms = rooms;
        print("Successfully parsed rooms: $allRooms");
      } catch (e, stackTrace) {
        print("Error while parsing rooms: $e");
        print("StackTrace: $stackTrace");
      }

      return allRooms;
    } else {
      print('we are gettig here');
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<GetRooms>> fetchRoomsByHouse(int houseId) async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
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

Future<String> postRoomsByHouse(int houseId, GetRooms newRoom) async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.post(
      Uri.parse('$devUrl/houses/getRooms/'),
      headers: headersWithToken,
      body: jsonEncode([newRoom.tojson()]),
    );

    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('failed to post new room  ${response.statusCode}');
    }
  } catch (e) {
    rethrow;
  }
}
