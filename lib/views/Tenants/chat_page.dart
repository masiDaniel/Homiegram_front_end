import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final ChatRoom chat;
  final String token;
  final String userEmail;

  const ChatPage({
    Key? key,
    required this.chat,
    required this.token,
    required this.userEmail,
  }) : super(key: key);

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
        '$chatUrl/ws/chat/${widget.chat.name}/?token=${widget.token}');
    channel = WebSocketChannel.connect(wsUrl);

    // Listen for incoming messages
    channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      setState(() {
        messages.add(Message(
          sender: decoded['sender'],
          content: decoded['message'],
          timestamp: DateTime.parse(decoded['timestamp']),
          chatroomId: widget.chat.id,
        ));
      });
    });
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
    final message = {"message": _controller.text.trim()};
    channel.sink.add(jsonEncode(message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColorMe =
        isDark ? const Color(0xFF4F9E4F) : const Color(0xFFDCF8C6);
    final bubbleColorOther =
        isDark ? const Color(0xFF33373D) : const Color(0xFFF0F0F0);
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFEDEDED);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
        backgroundColor: isDark ? Colors.black : const Color(0xFF105A01),
      ),
      backgroundColor: bgColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMe = msg.sender == widget.userEmail;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? bubbleColorMe : bubbleColorOther,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isMe
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: isMe
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.content,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.grey[200] : Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          TimeOfDay.fromDateTime(msg.timestamp).format(context),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(30),
                color: isDark ? Colors.black : Colors.white,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: isDark ? Colors.grey[900] : Colors.grey[100],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color:
                                  isDark ? Colors.grey[500] : Colors.grey[700],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: isDark
                            ? const Color.fromARGB(255, 80, 151, 26)
                            : const Color(0xFF105A01),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



//  children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 final isMe = msg.sender == widget.userEmail;

//                 return Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   child: Row(
//                     mainAxisAlignment:
//                         isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width * 0.7),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blue[100] : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: isMe
//                               ? CrossAxisAlignment.end
//                               : CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               msg.sender,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(msg.content),
//                             const SizedBox(height: 4),
//                             Text(
//                               TimeOfDay.fromDateTime(msg.timestamp)
//                                   .format(context),
//                               style: const TextStyle(
//                                   fontSize: 10, color: Colors.black54),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     onTap: () {},
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],