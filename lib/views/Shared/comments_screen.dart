import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/post_comments.dart';
import 'package:homi_2/services/comments_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

class CommentsScreen extends StatefulWidget {
  final GetHouse house;
  const CommentsScreen({super.key, required this.house});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<GetComments> _comments = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userId = id ?? 0; // Default to 'tenant' if null
    });
  }

  Future<void> _fetchComments() async {
    List<GetComments> comments = await fetchComments(widget.house.houseId);
    setState(() {
      _comments = comments; // Initialize the local comments list
    });
  }

  void addComment(String comment) async {
    await PostComments.postComment(
      houseId: widget.house.houseId.toString(),
      userId: userId.toString(),
      comment: comment,
      nested: true,
      nestedId: '3',
    );

    // After adding the comment, fetch the updated comments list
    await _fetchComments(); // Re-fetch comments
  }

  void _submitComment(TextEditingController commentController) {
    final String comment = commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
    } else {
      addComment(comment);
      commentController.clear();
    }
  }

  /// how should i refactor this?
  /// have it in a seperate file?
  Future<void> deleteComment(int commentId) async {
    String? token = await UserPreferences.getAuthToken();
    String url = '$devUrl/comments/deleteComments/$commentId/';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    try {
      // Send DELETE request
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 204) {
        // Comment deleted successfully
        setState(() {
          _comments.removeWhere((comment) =>
              comment.commentId == commentId); // Remove from local list
        });
      } else if (response.statusCode == 404) {
        // Check if the widget is still mounted before using the context
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment already deleted')),
        );
      } else {
        // Check if the widget is still mounted before using the context
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('We have problems')),
        );
      }
    } catch (e) {
      // Check if the widget is still mounted before using the context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting comment')),
      );
    }
  }

  Future<void> onReact(int commentId, String action) async {
    final userId = await UserPreferences.getUserId();
    String? token = await UserPreferences.getAuthToken();
    if (userId == null) return;
    final url = Uri.parse("$devUrl/comments/post/");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token $token',
      },
      body: jsonEncode({
        "comment_id": commentId,
        "action": action, // "like" or "dislike"
        "user_id": userId
      }),
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);

      // Update UI
      setState(() {
        // final index = widget.comments.indexWhere((c) => c.commentId == commentId);
        // if (index != -1) {
        //   if (action == "like") {
        //     widget.comments[index].likes?.add(userId);
        //     widget.comments[index].dislikes?.remove(userId);
        //   } else if (action == "dislike") {
        //     widget.comments[index].dislikes?.add(userId);
        //     widget.comments[index].likes?.remove(userId);
        //   }
        // }
      });
    } else {
      log("Failed to react: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CommentList(
              comments: _comments,
              onDelete: deleteComment,
              onReact: onReact,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tell us about ${widget.house.name}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF126E06)),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: 'Your comment',
                      labelStyle: TextStyle(color: Color(0xFF126E06)),
                    ),
                    cursorColor: const Color(0xFF126E06),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _submitComment(commentController);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(18, 110, 6, 1),
                      foregroundColor: Colors.white,
                      shadowColor: const Color.fromARGB(255, 30, 185, 30),
                      elevation: 5,
                    ),
                    child: const Text('Post Comment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  final List<GetComments> comments;
  final Function(int, String) onReact;
  final Function(int) onDelete;

  const CommentList({
    required this.comments,
    required this.onReact,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  int? userId;
  Map<int, int> likesMap = {}; // Store likes count
  Map<int, int> dislikesMap = {}; // Store dislikes count

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _initializeReactionCounts();
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userId = id ?? 0;
    });
  }

  void _initializeReactionCounts() {
    for (var comment in widget.comments) {
      likesMap[comment.commentId] = comment.likes;
      dislikesMap[comment.commentId] = comment.dislikes;
    }
  }

  void _handleReact(int commentId, String reactionType) {
    setState(() {
      if (reactionType == "like") {
        likesMap[commentId] = (likesMap[commentId] ?? 0) + 1;
      } else {
        dislikesMap[commentId] = (dislikesMap[commentId] ?? 0) + 1;
      }
    });

    // Call backend to update database
    widget.onReact(commentId, reactionType);
  }

  @override
  Widget build(BuildContext context) {
    Map<int?, List<GetComments>> groupedComments = {};

    for (var comment in widget.comments) {
      groupedComments.putIfAbsent(comment.parent, () => []).add(comment);
    }

    List<GetComments> rootComments = groupedComments[null] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rootComments.length,
          itemBuilder: (context, index) {
            final comment = rootComments.reversed.toList()[index];
            return _buildCommentTile(comment, groupedComments);
          },
        ),
      ],
    );
  }

  Widget _buildCommentTile(
      GetComments comment, Map<int?, List<GetComments>> groupedComments,
      {int depth = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 20.0, top: 4, bottom: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 67, 134, 59),
          border: Border.all(color: const Color(0xFF126E06), width: 1.0),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.comment,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _handleReact(comment.commentId, "like"),
                      icon: const Icon(Icons.thumb_up,
                          size: 20, color: Colors.white),
                    ),
                    Text(
                      "${likesMap[comment.commentId] ?? comment.likes}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _handleReact(
                        comment.commentId,
                        "dislike",
                      ),
                      icon: const Icon(Icons.thumb_down,
                          size: 20, color: Colors.white),
                    ),
                    Text(
                        "${dislikesMap[comment.commentId] ?? comment.dislikes}",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                if (comment.userId == userId)
                  IconButton(
                    onPressed: () => widget.onDelete(comment.commentId),
                    icon: const Icon(Icons.delete, color: Colors.white),
                  ),
              ],
            ),
            if (groupedComments.containsKey(comment.commentId))
              ...groupedComments[comment.commentId]!
                  .map((reply) => _buildCommentTile(reply, groupedComments,
                      depth: depth + 1))
                  .toList(),
          ],
        ),
      ),
    );
  }
}
