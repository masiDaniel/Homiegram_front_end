import 'package:flutter/material.dart';
import 'package:homi_2/models/bookmark.dart';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/post_comments.dart';
import 'package:homi_2/services/comments_service.dart';
import 'package:homi_2/services/rent_room_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

class SpecificHouseDetailsScreen extends StatefulWidget {
  final GetHouse house;

  const SpecificHouseDetailsScreen({super.key, required this.house});

  @override
  State<SpecificHouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<SpecificHouseDetailsScreen> {
  List<getComments> _comments = []; // Local comments list

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    List<getComments> comments = await fetchComments(widget.house.HouseId);
    setState(() {
      _comments = comments; // Initialize the local comments list
    });
  }

  void addComment(String comment) async {
    await PostComments.postComment(
      houseId: widget.house.HouseId.toString(),
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

  Future<void> deleteComment(int commentId) async {
    String url = '$azurebaseUrl/comments/deleteComments/$commentId/';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $authToken',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment already deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('We have problems')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting comment')),
      );
    }
  }

  // This map will store the bookmark state for each house by its HouseId
  Map<int, bool> bookmarkedHouses = {};

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.house.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              height: 500,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var imageUrl in widget.house.images!)
                    Image.network(
                      '$azurebaseUrl$imageUrl',
                      width: 500,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${widget.house.description}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('Rent Amount: ${widget.house.rent_amount}'),
                  Text('Rating: ${widget.house.rating}'),
                  Text('Location: ${widget.house.location}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tell us about ${widget.house.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _submitComment(commentController);
                    },
                    child: const Text('Post Comment'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CommentList(
              comments: _comments,
              onDelete: deleteComment, // Pass the delete function
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  int houseId = widget.house.HouseId;

                  // Check if the house is already bookmarked
                  if (bookmarkedHouses[houseId] == true) {
                    // Remove bookmark
                    PostBookmark.removeBookmark(houseId: houseId).then((_) {
                      print("Bookmark removed successfully.");
                      setState(() {
                        bookmarkedHouses[houseId] = false;
                      });
                      // Show a success alert for unbookmarking
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Bookmark Removed'),
                            content: const Text(
                                'This house has been removed from your bookmarks.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((error) {
                      print("Error occurred while removing bookmark: $error");
                    });
                  } else {
                    // Add bookmark
                    PostBookmark.postBookmark(houseId: houseId).then((_) {
                      print("Bookmark added successfully.");
                      setState(() {
                        bookmarkedHouses[houseId] = true;
                      });
                      // Show a success alert for bookmarking
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Bookmarked'),
                            content: Text(
                                '${widget.house.name} has been added to your bookmarks.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((error) {
                      print("Error occurred while bookmarking: $error");
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(150, 60), // Adjust size for better button
                  backgroundColor: const Color(0xFF126E06), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  shadowColor: Colors.black.withOpacity(0.3), // Shadow effect
                  elevation: 8, // Increased depth for elevation
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15), // More padding for easier tap
                  side: const BorderSide(
                      color: Color(0xFF0B4B02),
                      width: 2), // Border for more emphasis
                ),
                child: const Text(
                  'Bookmark',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20), // Space between buttons
              ElevatedButton(
                onPressed: () async {
                  int houseId = widget.house.HouseId;

                  // Call the rentRoom function
                  String? message = await rentRoom(houseId);

                  // Check the message and display feedback to the user
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(message == "Room successfully rented!"
                            ? 'Success'
                            : 'Error'),
                        content:
                            Text(message ?? 'An unexpected error occurred.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 100), // Increased size
                  backgroundColor: const Color(0xFF126E06), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  shadowColor: Colors.black.withOpacity(0.3), // Shadow effect
                  elevation: 8, // Depth for elevation
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15), // Increase padding for better touch
                  side: const BorderSide(
                      color: Color(0xFF0B4B02),
                      width: 2), // Border for extra emphasis
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: Colors.white), // House icon
                    SizedBox(width: 10),
                    Text(
                      'Rent',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final List<getComments> comments;
  final Function(int) onDelete; // Callback for deleting comments

  const CommentList({
    required this.comments,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

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
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments.reversed.toList()[
                index]; // reverse the list inorder to show the latest comments first

            return Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Expanded(child: Text(comment.comment)),
                if (comment.userId == userId)
                  IconButton(
                    onPressed: () {
                      onDelete(comment.commentId); // Use the callback
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
              ]),
            );
          },
        ),
      ],
    );
  }
}
