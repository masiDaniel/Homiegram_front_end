class Chat {
  final String chatName;
  final String lastMessage;
  final int unreadMessage;

  Chat({
    required this.chatName,
    required this.lastMessage,
    this.unreadMessage = 0,
  });
}
