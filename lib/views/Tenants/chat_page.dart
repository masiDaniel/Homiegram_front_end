import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final ChatRoom chat;
  final String token;
  final int userId;

  const ChatPage(
      {Key? key, required this.chat, required this.token, required this.userId})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketChannel channel;
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final wsUrl = Uri.parse(
        'ws://192.168.100.18:8000/ws/chat/${widget.chat.name}/?token=${widget.token}');
    channel = WebSocketChannel.connect(wsUrl);

    // Listen for incoming messages
    channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      print("this is the decoded data $decoded");
      setState(() {
        messages.add(Message(
          sender: decoded['sender'],
          content: decoded['message'],
          timestamp: DateTime.parse(decoded['timestamp']),
          chatroomId: widget.chat.id,
        ));
      });
    });

    print("this si the message ${widget.chat.messages}");
    messages = widget.chat.messages;
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = {
      "message": _controller.text.trim(),
    };
    print("this is the json ${jsonEncode(message)}");

    channel.sink.add(jsonEncode(message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.sender == widget.userId.toString();
                print("this is me ${widget.userId.toString()}");
                print("this is the sender ${msg.sender}");
                print("this is the condition $isMe");

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.sender,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(msg.content),
                            const SizedBox(height: 4),
                            Text(
                              TimeOfDay.fromDateTime(msg.timestamp)
                                  .format(context),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onTap: () {},
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
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
