import 'package:flutter/material.dart';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/post_comments.dart';
import 'package:homi_2/services/comments_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

/// i dont understand the data flow in this section and it should be reviewed
/// also the GetHouse houses bit of the code
/// i wan to understand how setstate works so that the comments can reflect instantly when added or deleted

class specificHouseDetailsScreen extends StatefulWidget {
  final GetHouse house;

  const specificHouseDetailsScreen({super.key, required this.house});

  @override
  State<specificHouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<specificHouseDetailsScreen> {
  late Future<List<getComments>> _commentsFuture;
  List<getComments> _comments = [];

  @override
  void initState() {
    super.initState();
    _commentsFuture = fetchComments(widget.house.HouseId);
  }

  void addComment(String comment) {
    PostComments.postComment(
      houseId: widget.house.HouseId.toString(),
      userId: userId.toString(),
      comment: comment,
      nested: true,
      nestedId: '3',
    );
    //the setstate bellow does not affect anything
    setState(() {
      getComments newComment = getComments(
        commentId: 0,
        houseId: 2,
        userId: 2,
        comment: comment,
        nested: false,
        nestedId: '0',
      );
      _comments.insert(0, newComment);
    });
  }

  void _submitComment(TextEditingController commentController) {
    final String comment = commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('comment cannot be empty')),
      );
    } else {
      addComment(comment);
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.house.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
                height: 500,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var imageUrl in widget.house.images)
                      Image.network(
                        '$baseUrl$imageUrl',
                        width: 500,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                  ],
                )),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${widget.house.description}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Rent Amount: ${widget.house.rent_amount}'),
                  Text('Rating: ${widget.house.rating}'),
                  Text('Location: ${widget.house.location}'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Tell us about ${widget.house.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: commentController,
                    decoration:
                        const InputDecoration(labelText: 'Your comment'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _submitComment(commentController);
                        setState(() {});
                      },
                      child: const Text('Post Comment'))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: _commentsFuture,
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return CommentList(
                    comments: snapshot.data!,
                  );
                } else {
                  return const Center(child: Text('No comments available'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  final List<getComments> comments;
  const CommentList({
    required this.comments,
    Key? key,
  }) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  String baseUrl = 'http://127.0.0.1:8000';
  void deleteComment(int commentId) async {
    String url = '$baseUrl/comments/deleteComments/$commentId/';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
    };

    try {
      // Send DELETE request
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 204) {
        // Comment deleted successfully
        // Refresh the comments list or remove the deleted comment from the list
        setState(() {});
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('comment already deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('we have problems')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('comment cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            final comment = widget.comments[index];

            return Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Expanded(
                  child: Text(comment.comment),
                ),
                if (comment.userId == userId)
                  IconButton(
                      onPressed: () {
                        deleteComment(comment.commentId);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      )),
              ]),
            );
          },
        ),
      ],
    );
  }
}
