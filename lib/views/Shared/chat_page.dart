import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';

class ChatCard extends StatefulWidget {
  final Chat chat;

  const ChatCard({required this.chat, Key? key}) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool isRead = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/hg.png'),
              radius: 28.0, // Adjust the size as needed
            ),
            title: Text(widget.chat.chatName),
            subtitle: Text(widget.chat.lastMessage),
            trailing: isRead || widget.chat.unreadMessage == 0
                ? const Icon(Icons.check_circle, color: Colors.grey)
                : const Icon(Icons.circle, color: Colors.green),
            isThreeLine:
                true, // Enable this if you want to allow three lines of text
            dense: true, // Use dense to adjust the height of the tile
            onTap: () {
              setState(() {
                isRead = true; // Mark as read when tapped
              });
              Navigator.pushNamed(context, '/chatScreen');
            },
          ),
        ),
      ),
    );
  }
}
