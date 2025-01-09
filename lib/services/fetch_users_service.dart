import 'dart:convert';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

Future<List<GetComments>> fetchUsers() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/accounts/getUsers/'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> commentData = json.decode(response.body);

      final List<GetComments> comments =
          commentData.map((json) => GetComments.fromJSon(json)).toList();

      return comments;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}
