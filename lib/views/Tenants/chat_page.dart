import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';

class ChatPage extends StatelessWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.chatName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Number of sample messages
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      chat.chatName[0], // First letter of chat name as avatar
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('Message $index from ${chat.chatName}'),
                  subtitle: Text('This is message $index content.'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Logic to send a message will be added when the functionaly is added
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
