import 'dart:convert';
import 'package:homi_2/chat%20feature/DB/chat_db_helper.dart';
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
    final chatRooms = data.map((item) => ChatRoom.fromJson(item)).toList();

    // Save fetched chat rooms to SQLite
    final dbHelper = DatabaseHelper();
    for (var room in chatRooms) {
      await dbHelper.insertOrUpdateChatroom({
        'id': room.id,
        'name': room.name,
        'label': room.label,
        'participants': json.encode(room.participants),
        'last_message': room.lastMessage != null
            ? json.encode(room.lastMessage!.toJson())
            : null,
        'is_group': room.isGroup ? 1 : 0,
        'updated_at': room.updatedAt.toIso8601String(),
      });
    }
    List<ChatRoom> rooms = await dbHelper.getChatRooms();
    for (var room in rooms) {
      print(
          'ChatRoom id: ${room.id}, name: ${room.name}, updatedAt: ${room.updatedAt}');
    }
    return chatRooms;
  } else {
    throw Exception('Failed to load chat rooms');
  }
}
