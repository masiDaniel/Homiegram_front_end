import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';

///
///this is not being used as of now
///
///
class ChatOcc extends StatelessWidget {
  final Chat chat;
  const ChatOcc({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          chat.chatName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(chat.lastMessage),
        trailing: chat.unreadMessage > 0
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.message,
                    size: 24,
                  ),
                  Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 55, 172, 61),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 24,
                          maxWidth: 24,
                        ),
                        child: Center(
                          child: Text(
                            chat.unreadMessage.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              )
            : const Icon(Icons.message),
      ),
    );
  }
}
