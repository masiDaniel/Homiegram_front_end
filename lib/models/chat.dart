class Chat {
  String chatName;
  String lastMessage;
  int unreadMessage;

  Chat({
    required this.chatName,
    required this.lastMessage,
    required this.unreadMessage,
  });

  void markAsRead() {
    unreadMessage = 0;
  }
}
