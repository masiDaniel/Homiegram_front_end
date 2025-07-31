import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';

class ChatCard extends StatefulWidget {
  final ChatRoom chat;

  const ChatCard({required this.chat, Key? key}) : super(key: key);

  @override
  ChatCardState createState() => ChatCardState();
}

class ChatCardState extends State<ChatCard> {
  bool isRead = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/hg.png'),
              radius: 28.0, // Adjust the size as needed
            ),
            title: Text(widget.chat.name),
            subtitle: const Text("chats"),
            // trailing: isRead || widget.chat.unreadMessage == 0
            //     ? const Icon(Icons.check_circle, color: Colors.grey)
            //     : const Icon(Icons.circle, color: Colors.green),
            isThreeLine:
                false, // Enable this if you want to allow three lines of text
            dense: true, // Use dense to adjust the height of the tile
          ),
        ),
      ),
    );
  }
}
