import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:homi_2/models/bookmark.dart';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/post_comments.dart';
import 'package:homi_2/services/comments_service.dart';
import 'package:homi_2/services/fetch_bookmarks.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/rent_room_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

class SpecificHouseDetailsScreen extends StatefulWidget {
  final GetHouse house;

  const SpecificHouseDetailsScreen({super.key, required this.house});

  @override
  State<SpecificHouseDetailsScreen> createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<SpecificHouseDetailsScreen> {
  List<GetComments> _comments = []; // Local comments list
  late Future<List<GetHouse>> bookmarkedHousesFuture;
  bool isBookmarked = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _loadUserId();

    bookmarkedHousesFuture = fetchBookmarkedHouses();

    // Check if the current house is bookmarked
    bookmarkedHousesFuture.then((bookmarkedHouses) {
      setState(() {
        isBookmarked = bookmarkedHouses
            .any((house) => house.houseId == widget.house.houseId);
      });
    }).catchError((error) {
      // Handle errors gracefully
      debugPrint("Error fetching bookmarked houses: $error");
    });
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

  // This map will store the bookmark state for each house by its houseId
  Map<int, bool> bookmarkedHouses = {};

  Future<List<GetHouse>> fetchBookmarkedHouses() async {
    int? id = await UserPreferences.getUserId();
    //Fetch the bookmarks for the user
    final bookmarks = await fetchBookmarks();
    List<GetHouse> allHouses = await fetchHouses();

    // Extract the house IDs from the bookmarks
    final houseIdsForCurrentUser = bookmarks
        .where((bookmark) => bookmark.user == id) // Filter by current user
        .map((bookmark) => bookmark.house) // Extract house ID
        .toList(); // Convert to a list

    // Filter houses by matching ids
    List<GetHouse> filteredHouses = allHouses.where((house) {
      return houseIdsForCurrentUser
          .contains(house.houseId); // Check if house ID is in the user's list
    }).toList();

    return filteredHouses;
  }

  Future<void> onReact(int commentId, String action) async {
    final userId = await UserPreferences.getUserId(); // Retrieve user ID
    if (userId == null) return; // Ensure user ID is available

    final url = Uri.parse(
        "https://your-api-url.com/comments/react/"); // Update with your API endpoint

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "comment_id": commentId,
        "action": action, // "like" or "dislike"
        "user_id": userId
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data["message"]); // "Comment liked" or "Comment disliked"

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
      print("Failed to react: ${response.body}");
    }
  }

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
            SizedBox(
              height: 500,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var imageUrl in widget.house.images!)
                    Image.network(
                      '$devUrl$imageUrl',
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
                  Text('Rent Amount: ${widget.house.rentAmount}'),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF126E06), // Green color
                      foregroundColor: Colors.white, // Text color
                      shadowColor:
                          const Color.fromARGB(255, 9, 17, 9), // Shadow color
                      elevation:
                          5, // Optional: Adjust elevation for shadow effect
                    ),
                    child: const Text('Post Comment'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CommentList(
              comments: _comments,
              onDelete: deleteComment,
              onReact: onReact,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  int houseId = widget.house.houseId;

                  // Check if the house is already bookmarked
                  if (isBookmarked) {
                    // Remove bookmark
                    PostBookmark.removeBookmark(houseId: houseId).then((_) {
                      setState(() {
                        isBookmarked = false;
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
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            const Color(0xFF186E1B))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((error) {
                      log("Error occurred while removing bookmark: $error");
                    });
                  } else {
                    // Add bookmark
                    PostBookmark.postBookmark(houseId: houseId).then((_) {
                      setState(() {
                        isBookmarked = true;
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
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            const Color(0xFF186E1B))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).catchError((error) {
                      log("Error occurred while bookmarking: $error");
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF126E06), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),

                  elevation: 8, // Increased depth for elevation
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // More padding for easier tap
                ),
                child: Text(
                  isBookmarked ? 'Remove Bookmark' : 'Bookmark',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20), // Space between buttons
              ElevatedButton(
                onPressed: () async {
                  String? userTypeShared = await UserPreferences.getUserType();
                  // Assuming you have a variable `userType` that holds the user's type
                  if (userTypeShared == "landlord") {
                    // Show an error dialog to inform the landlord they cannot rent a room
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Landlords cannot rent rooms.'),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color(0xFF186E1B))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    int houseId = widget.house.houseId;

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
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color(0xFF186E1B))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF126E06), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),

                  elevation: 8, // Depth for elevation
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Increase padding for better touch
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

class CommentList extends StatefulWidget {
  final List<GetComments> comments;
  final Function(int) onDelete;
  final Function(int, String) onReact; // Callback for like/dislike

  const CommentList({
    required this.comments,
    required this.onDelete,
    required this.onReact, // New callback
    Key? key,
  }) : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userId = id ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<int?, List<GetComments>> groupedComments = {};

    // Group comments by parent ID
    for (var comment in widget.comments) {
      groupedComments.putIfAbsent(comment.parent, () => []).add(comment);
    }

    List<GetComments> rootComments =
        groupedComments[null] ?? []; // Root level comments

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
            print('this is a comment ${comment}');
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
      padding: EdgeInsets.only(left: depth * 20.0), // Indent replies
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF126E06)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(comment.comment)),
              Row(
                children: [
                  IconButton(
                    onPressed: () => widget.onReact(comment.commentId, "like"),
                    icon: const Icon(Icons.thumb_up, color: Colors.grey),
                  ),
                  Text("${comment.likes}"), // Display total likes

                  IconButton(
                    onPressed: () =>
                        widget.onReact(comment.commentId, "dislike"),
                    icon: const Icon(Icons.thumb_down, color: Colors.grey),
                  ),
                  Text("${comment.dislikes}"), // Display total dislikes
                ],
              ),
              if (comment.userId == userId)
                IconButton(
                  onPressed: () {
                    widget.onDelete(comment.commentId);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xFF126E06),
                  ),
                ),
            ]),
            // Render replies if any
            if (groupedComments.containsKey(comment.commentId))
              Column(
                children: groupedComments[comment.commentId]!
                    .map((reply) => _buildCommentTile(reply, groupedComments,
                        depth: depth + 1))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
