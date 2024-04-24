import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/comments_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class HouseDetailsScreen extends StatefulWidget {
  final GetHouse house;

  const HouseDetailsScreen({required this.house});

  @override
  State<HouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  late Future<List<getComments>> _commentsFuture;
  List<getComments> _comments = [];

  @override
  void initState() {
    super.initState();
    _commentsFuture = fetchComments(2);
  }

  void addComment(String comment) {
    setState(() {
      getComments newComment = getComments(
        commentId: 0,
        houseId: 2,
        userId: 0,
        comment: comment,
        nested: false,
        nestedId: '0',
      );
      _comments.insert(0, newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.house.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    'description: ${widget.house.description}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('rent amount: ${widget.house.rent_amount}'),
                  Text('rating: ${widget.house.rating}'),
                  Text('location: ${widget.house.location}'),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'add a comment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            CommentForm(addComment: addComment),
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
                  return CommentList(comments: snapshot.data!);
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

class CommentForm extends StatefulWidget {
  final Function(String) addComment;

  const CommentForm({required this.addComment, Key? key}) : super(key: key);

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final TextEditingController _commentController = TextEditingController();

  void _submitComment() {
    final String comment = _commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('comment cannot be empty')),
      );
    } else {
      widget.addComment(comment);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: 'Your comment'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: _submitComment, child: const Text('post comment'))
        ],
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  final List<getComments> comments;
  const CommentList({required this.comments, Key? key}) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'comments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                if (comment.userId == UserId)
                  IconButton(
                      onPressed: () {},
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
