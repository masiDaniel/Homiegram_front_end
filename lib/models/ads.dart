import 'dart:convert';
import 'package:http/http.dart' as http;

class Ad {
  final String? imageUrl;
  final String? videoUrl;

  Ad({this.imageUrl, this.videoUrl});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      imageUrl: json['image'] as String?,
      videoUrl: json['video_file'] as String?,
    );
  }
}

Future<List<Ad>> fetchAds() async {
  final response =
      await http.get(Uri.parse('https://127.0.0.1:8000/houses/getAdvertss/'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((ad) => Ad.fromJson(ad)).toList();
  } else {
    throw Exception('Failed to load advertisements');
  }
}
