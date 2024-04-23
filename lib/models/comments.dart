class getComments {
  final int commentId;
  final int houseId;
  final int userId;
  final String comment;
  final bool nested;
  final String nestedId;

  getComments({
    required this.commentId,
    required this.houseId,
    required this.userId,
    required this.comment,
    required this.nested,
    required this.nestedId,
  });

  factory getComments.fromJSon(Map<String, dynamic> json) {
    return getComments(
      commentId: json['id'] ?? 0,
      houseId: json['house_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      comment: json['comment'] ?? '',
      nested: json['nested'] ?? false,
      nestedId: json['nested_id'] ?? 0,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "id": commentId,
      "house_id": houseId,
      "user_id": userId,
      "comment": comment,
      "nested": nested,
      "nested_id": nestedId
    };
  }
}
