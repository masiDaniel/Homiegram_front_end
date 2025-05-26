import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homi_2/models/bookmark.dart';
import 'package:homi_2/models/comments.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/models/post_comments.dart';
import 'package:homi_2/services/comments_service.dart';
import 'package:homi_2/services/fetch_bookmarks.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/get_locations.dart';
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
  late Future<List<Locations>> futureLocations;
  List<Locations> locations = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _loadUserId();
    _fetchLocations();

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

  Future<void> _fetchLocations() async {
    try {
      List<Locations> fetchedLocations = await fetchLocations();
      setState(() {
        locations = fetchedLocations;
      });
    } catch (e) {
      log('error fetching locations!');
    }
  }

  String getLocationName(int locationId) {
    final location = locations.firstWhere(
      (loc) => loc.locationId == locationId,
      orElse: () => Locations(
        locationId: 0,
        area: "unknown",
      ), // Default value if not found
    );
    return '${location.area}, ${location.town}, ${location.county}';
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.house.name),
        backgroundColor: const Color(0xFF126E06),
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(31, 2, 245, 2),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'House Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF126E06),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.description, color: Color(0xFF126E06)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.house.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Color(0xFF126E06)),
                      const SizedBox(width: 8),
                      Text('Rent: KES ${widget.house.rentAmount}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Rating:', style: TextStyle(fontSize: 16)),
                      buildSimpleStars(widget.house.rating.toDouble())
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF126E06)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                            'Location ${getLocationName(widget.house.location_detail)}',
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tell us about ${widget.house.name}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF126E06)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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

  Widget buildSimpleStars(double rating) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Color(0xFF126E06),
      ),
      itemCount: 5,
      itemSize: 20.0,
      direction: Axis.horizontal,
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _handleReact(comment.commentId, "like"),
                      icon: const Icon(Icons.thumb_up,
                          size: 20, color: Colors.grey),
                    ),
                    Text("${likesMap[comment.commentId] ?? comment.likes}"),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () =>
                          _handleReact(comment.commentId, "dislike"),
                      icon: const Icon(Icons.thumb_down,
                          size: 20, color: Colors.grey),
                    ),
                    Text(
                        "${dislikesMap[comment.commentId] ?? comment.dislikes}"),
                  ],
                ),
                if (comment.userId == userId)
                  IconButton(
                    onPressed: () => widget.onDelete(comment.commentId),
                    icon: const Icon(Icons.delete, color: Color(0xFF126E06)),
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
