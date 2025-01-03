import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

class PostBookmark {
  static Future<void> postBookmark({
    required int houseId,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/houses/bookmark/add/$houseId/"),
        headers: headers,
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

  static Future<void> removeBookmark({
    required int houseId,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/houses/bookmark/remove/$houseId/"),
        headers: headers,
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
