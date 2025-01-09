import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homi_2/models/bookmark.dart';

Future<List<Bookmark>> fetchBookmarks(int userId) async {
  final response = await http
      .get(Uri.parse('https://api.example.com/bookmarks?user=$userId'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((bookmark) => Bookmark.fromJson(bookmark)).toList();
  } else {
    throw Exception('Failed to load bookmarks');
  }
}
