import 'dart:convert';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

class PostComments {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<void> postComment({
    required String houseId,
    required String userId,
    required String comment,
    required bool nested,
    required String nestedId,
  }) async {
    const String url = '$baseUrl/comments/post/';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };

    final Map<String, dynamic> body = {
      "house_id": houseId,
      "user_id": userId,
      "comment": comment,
      "nested": nested,
      "nested_id": nestedId,
    };
    final String requestBody = json.encode(body);
    print(requestBody);
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/comments/post/"),
        headers: headers,
        body: jsonEncode({
          "house_id": houseId,
          "user_id": userId,
          "comment": comment,
          "nested": nested,
          "nested_id": nestedId
        }),
      );
      print(
        jsonEncode({
          "house_id": houseId,
          "user_id": userId,
          "comment": comment,
          "nested": nested,
          "nested_id": nestedId
        }),
      );
      if (response.statusCode == 200) {
        print('comment posted succesfully!');
      } else {
        print('failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      print('error positng comment: $e');
    }
  }
}
