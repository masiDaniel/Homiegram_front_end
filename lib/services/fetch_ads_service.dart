import 'dart:convert';
import 'dart:developer';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

Future<List<Ad>> fetchAds() async {
  String? token = await UserPreferences.getAuthToken();

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token',
  };

  final response = await http.get(
    Uri.parse('$devUrl/houses/getAdverts/'),
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

Future<AdRequest> postAds(AdRequest adRequest) async {
  String? token = await UserPreferences.getAuthToken();
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token',
  };

  final response = await http.post(
    Uri.parse('$devUrl/houses/submitAdvertisment/'),
    headers: headers,
    body: jsonEncode(adRequest.toJson()), // Properly encode the body
  );

  if (response.statusCode == 201) {
    log("Ad submission was successful");

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return AdRequest.fromJson(jsonResponse); // Correct parsing
  } else {
    log("Failed to submit advertisement: ${response.body}");
    throw Exception('Failed to submit advertisements');
  }
}
