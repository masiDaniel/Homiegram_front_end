class Message {
  final int? id;
  final int chatroomId;
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    this.id,
    required this.chatroomId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatroomId: json['chatroom'],
      sender: json['sender'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatRoom {
  final int id;
  final String name;
  final List<int> participants;
  final List<Message> messages;
  final bool isGroup;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.messages,
    required this.isGroup,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      participants: List<int>.from(json['participants']),
      messages: (json['messages'] as List<dynamic>)
          .map((m) => Message.fromJson(m))
          .toList(),
      isGroup: json["is_group"],
    );
  }
}
