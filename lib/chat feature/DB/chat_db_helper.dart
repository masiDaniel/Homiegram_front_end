import 'dart:convert';

import 'package:homi_2/models/chat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chatrooms (
        id INTEGER PRIMARY KEY,
        name TEXT,
        label TEXT,
        participants TEXT,
        last_message TEXT,
        is_group INTEGER,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY,
        chatroom_id INTEGER,
        sender TEXT,
        content TEXT,
        timestamp TEXT,
        FOREIGN KEY (chatroom_id) REFERENCES chatrooms (id)
      )
    ''');
  }

  // Insert or update chatroom
  Future<void> insertOrUpdateChatroom(Map<String, dynamic> chatroom) async {
    final db = await database;
    await db.insert(
      'chatrooms',
      chatroom,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert or update message
  Future<void> insertOrUpdateMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert(
      'messages',
      message,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatRoom>> getChatRooms() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('chatrooms');

    return List.generate(maps.length, (i) {
      return ChatRoom(
        id: maps[i]['id'],
        name: maps[i]['name'],
        label: maps[i]['label'],
        isGroup: maps[i]['is_group'] == 1,
        updatedAt: DateTime.parse(maps[i]['updated_at']),
        participants: maps[i]['participants'] != null
            ? List<int>.from(json.decode(maps[i]['participants']))
            : [],
        lastMessage: maps[i]['last_message'] != null
            ? Message.fromJson(json.decode(maps[i]['last_message']))
            : null,
        messages: [],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getMessagesForRoom(int chatroomId) async {
    final db = await database;
    return await db.query(
      'messages',
      where: 'chatroom_id = ?',
      whereArgs: [chatroomId],
      orderBy: 'timestamp ASC',
    );
  }
}
