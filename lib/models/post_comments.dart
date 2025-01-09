import 'dart:convert';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

/// also this, just like the bookmark issue
class PostComments {
  static Future<void> postComment({
    required String houseId,
    required String userId,
    required String comment,
    required bool nested,
    required String nestedId,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };
    try {
      final response = await http.post(
        Uri.parse("$devUrl/comments/post/"),
        headers: headers,
        body: jsonEncode({
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
