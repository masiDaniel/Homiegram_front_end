import 'dart:convert';

import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/user_sigin_service.dart';
// import 'package:homi_2/services/user_sigin_service.dart';

import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

String? houseId;

Future<List<GetHouse>> fetchHouses() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/houses/gethouses/'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> housesData = json.decode(response.body);

      final List<GetHouse> houses =
          housesData.map((json) => GetHouse.fromJSon(json)).toList();

      return houses;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}
