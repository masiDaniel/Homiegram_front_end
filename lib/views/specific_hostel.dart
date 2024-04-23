// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:homi_2/services/get_house_service.dart';
// import 'package:homi_2/services/user_sigin_service.dart';
// // import 'package:homi_2/services/user_sigin_service.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:homi_2/models/comments.dart';

// class SpecificHostel extends StatefulWidget {
//   ///
//   /// this page will be for the specific hostels
//   /// once the user clicks on the specific hostel they are looking to check,
//   /// they will be redirected to this page and will be able to view, book and bookmark the specific hotel
//   ///

//   final int houseId;
//   // final String authToken;
//   // required this.authToken

//   const SpecificHostel({Key? key, required this.houseId, }) : super(key: key);

//   @override
//   _SpecificHostelState createState() => _SpecificHostelState();
// }

// class _SpecificHostelState extends State<SpecificHostel> {
//   double _currentRating = 0;
//   List<String> comments = [];
//   late Future<dynamic> _houseDataFuture;

//   @override
//   void initState() {
//     super.initState();
//     _houseDataFuture = fetchHouses(authToken.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final containerHeight = screenHeight * 0.35;
//     final commentWidgets = comments.map((comment) => Text(comment)).toList();

//     return FutureBuilder(
//       future: _houseDataFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ),
//           );
//         } else {
//           final houseData = snapshot.data;
//           return Scaffold(
//             body: SingleChildScrollView(
//               // Wrap the entire body in a SingleChildScrollView to allow scrolling
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: containerHeight,
//                     color: Colors.amber,
//                     child: Stack(
//                       children: [
//                         Positioned(
//                             child: InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             // Your container properties here
//                             child: const Text('Go Back'),
//                           ),
//                         )),
//                         Positioned(
//                           top: 20,
//                           left: 0,
//                           child: Text(
//                             "${houseData != null ? houseData[1].name : 'no name'}",
//                             style: TextStyle(color: Colors.black, fontSize: 20),
//                           ),
//                         ),
//                         Positioned(
//                           left: 0,
//                           right: 0,
//                           bottom: 0,
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: <Widget>[
//                                 Image.asset("assets/images/1_2.jpeg"),
//                                 Image.asset("")
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // First section for house details
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: const Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           'House Details',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text('Location: Nairobi,athiriver'),
//                         Text('Price: 10500 per month'),
//                         Text('Rooms: bedsiters and one bedrooms'),
//                         Text('Amenities: Wi-Fi,  Pool'),
//                       ],
//                     ),
//                   ),
//                   // Second section for comments and reviews
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Comments and Reviews',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),

//                         // buildCommentTree(comments),
//                         // Example comment
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: commentWidgets,
//                         ),
//                         SizedBox(height: 10),
//                         // commnetInput,
//                         SizedBox(height: 10),
//                         StarRating(
//                           rating: _currentRating,
//                           onRatingChanged: (newRating) {
//                             setState(() {
//                               _currentRating = newRating;
//                             });
//                           },
//                         ),
//                         // Add more comments and reviews here
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class StarRating extends StatelessWidget {
//   final double rating;
//   final int maxRating;
//   final Function(double) onRatingChanged;

//   const StarRating({
//     Key? key,
//     required this.rating,
//     this.maxRating = 5,
//     required this.onRatingChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (details) {
//         // Calculate the index of the star that was tapped
//         final RenderBox box = context.findRenderObject() as RenderBox;
//         final Offset localPosition = box.globalToLocal(details.globalPosition);
//         final double starWidth = 24.0; // Assuming each star is 24.0 pixels wide
//         final int index = (localPosition.dx / starWidth).floor();
//         final double newRating = index + 1;
//         onRatingChanged(newRating);
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: List.generate(maxRating, (index) {
//           return Icon(
//             index < rating ? Icons.star : Icons.star_border,
//             color: Colors.amber,
//           );
//         }),
//       ),
//     );
//   }
// }


//comment and reviews 

  // void initState() {
  //   super.initState();
  //   fetchDataComments();
  // }

  // Future<void> fetchDataComments() async {
  //   final url = Uri.parse(
  //       'http://127.0.0.1:8000/comments/post/?house_id=${widget.houseId}');

  //   final headers = {
  //     'Authorization': 'Token $authToken',
  //   };

  //   final response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     final List<String> extractedComments = [];

  //     for (final commentData in jsonData) {
  //       final comment = Comment(
  //         id: commentData['id'] ?? 0,
  //         text: commentData['text'] ?? '',
  //         user: commentData['user'] ?? '',
  //         parentCommentId: commentData['nested_id'],
  //       );
  //       extractedComments.add(comment.text);
  //     }

  //     setState(() {
  //       comments = extractedComments;
  //     });
  //   } else {
  //     print("failed t0 load data: ${response.statusCode}");
  //   }
  // }

  // Future<void> submittComent(
  //     String commentText, String userId, String houseId) async {
  //   final url = Uri.parse('http://127.0.0.1:8000/comments/post/');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Token $authToken'
  //     },
  //     body: jsonEncode({
  //       'comment': commentText,
  //       'house_id': houseId,
  //       'user_id': userId,
  //       'nested': false,
  //       'nested_id': 'false'
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     fetchDataComments();
  //   } else {
  //     print("error occured");
  //   }
  // }

    // Widget commnetInput = TextField(
    //   onSubmitted: (value) {
    //     if (value.isNotEmpty) {
    //       submittComent(value, '2', widget.houseId.toString());
    //     }
    //   },
    //   decoration: const InputDecoration(
    //     labelText: 'Write a comment',
    //     border: OutlineInputBorder(),
    //   ),
    // );
  
  // buildCommentTree(List<String> comments) {
  //   List<Comment> nestedComments =
  //       []; // Fetch nested comments based on parentCommentId
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: nestedComments.length,
  //     itemBuilder: (context, index) {
  //       Comment nestedComment = nestedComments[index];
  //       return CommentWidget(comment: nestedComment);
  //     },
  //   );
  // }


// class CommentWidget extends StatelessWidget {
//   final Comment comment;

//   const CommentWidget({Key? key, required this.comment}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           title: Text(comment.text),
//           subtitle: Text(comment.user),
//         ),
//         if (comment.parentCommentId == null)
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: buildCommentTree(comment.id),
//           ),
//       ],
//     );
//   }

//   Widget buildCommentTree(int parentCommentId) {
//     List<Comment> nestedComments =
//         []; // Fetch nested comments based on parentCommentId
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: nestedComments.length,
//       itemBuilder: (context, index) {
//         Comment nestedComment = nestedComments[index];
//         return CommentWidget(comment: nestedComment);
//       },
//     );
//   }
// }
