import 'dart:convert';
import 'dart:developer';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

Future<List<Ad>> fetchAds() async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $authToken',
  };

  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/houses/getAdverts/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    log("ad feting was succesful");
    return jsonResponse.map((ad) => Ad.fromJson(ad)).toList();
  } else {
    throw Exception('Failed to load advertisements');
  }
}
