import 'dart:convert';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

Future<List<getComments>> fetchComments(int houseId) async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/comments/post/?house_id=$houseId'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> commentData = json.decode(response.body);
      // print(response.body);
      print("Fetched Comments");
      print(commentData);
      final List<getComments> comments =
          commentData.map((json) => getComments.fromJSon(json)).toList();
      // print(comments);
      return comments;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}
