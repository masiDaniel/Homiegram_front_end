import 'dart:convert';
import 'package:homi_2/models/chat.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

Future<List<ChatRoom>> fetchChatRooms() async {
  String? authToken;
  authToken = await UserPreferences.getAuthToken();
  final url = Uri.parse('$devUrl/chat/my-chat-rooms/');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Token $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => ChatRoom.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load chat rooms');
  }
}
