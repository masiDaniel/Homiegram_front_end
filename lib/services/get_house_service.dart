import 'dart:convert';

import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/user_sigin_service.dart';
// import 'package:homi_2/services/user_sigin_service.dart';

import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};
List<GetHouse> allHouses = [];
String? houseId;

// /this is used in the home_page class(commented out) and the house list page

Future<List<GetHouse>> fetchHouses() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(Uri.parse('$devUrl/houses/gethouses/'),
        headers: headersWithToken);

    print("auth token $authToken");

    if (response.statusCode == 200) {
      final List<dynamic> housesData = json.decode(response.body);

      final List<GetHouse> houses =
          housesData.map((json) => GetHouse.fromJSon(json)).toList();

      allHouses = houses;
      return houses;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}
