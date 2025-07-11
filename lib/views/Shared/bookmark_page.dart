import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homi_2/models/bookmark.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/fetch_bookmarks.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Shared/house_details_screen.dart';

class BookmarkedHousesPage extends StatefulWidget {
  final int userId;

  const BookmarkedHousesPage({super.key, required this.userId});

  @override
  BookmarkedHousesPageState createState() => BookmarkedHousesPageState();
}

class BookmarkedHousesPageState extends State<BookmarkedHousesPage> {
  late Future<List<GetHouse>> _bookmarkedHousesFuture;

  @override
  void initState() {
    super.initState();
    _bookmarkedHousesFuture = fetchBookmarkedHouses();
  }

  Future<List<GetHouse>> fetchBookmarkedHouses() async {
    //Fetch the bookmarks for the user
    final bookmarks = await fetchBookmarks();
    List<GetHouse> allHouses = await fetchHouses();

    // Extract the house IDs from the bookmarks
    final houseIdsForCurrentUser = bookmarks
        .where((bookmark) =>
            bookmark.user == widget.userId) // Filter by current user
        .map((bookmark) => bookmark.house) // Extract house ID
        .toList(); // Convert to a list

    // Filter houses by matching ids
    List<GetHouse> filteredHouses = allHouses.where((house) {
      return houseIdsForCurrentUser
          .contains(house.houseId); // Check if house ID is in the user's list
    }).toList();

    return filteredHouses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Houses')),
      body: FutureBuilder<List<GetHouse>>(
        future: _bookmarkedHousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.green, // Custom color
                    strokeWidth: 6.0, // Thicker stroke
                  ),
                  SizedBox(height: 10),
                  Text("Loading, please wait...",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              )),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final houses = snapshot.data!;

            if (houses.isEmpty) {
              return const Center(child: Text('No bookmarked houses.'));
            }

            return ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                final house = houses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SpecificHouseDetailsScreen(house: house),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (house.images?.isNotEmpty ?? false)
                          Image.network(
                            '$devUrl${house.images?.first}',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/splash.jpeg',
                            ),
                          ),
                        if (house.images?.isEmpty ?? true)
                          Image.asset(
                            'assets/images/splash.jpeg',
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            house.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Rent: ${house.rentAmount}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              const Text("Rating:"),
                              buildSimpleStars(house.rating.toDouble()),
                            ],
                          ),
                        ),
                        // Bookmarked button aligned to the right
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .end, // Align button to the right
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFF186E1B), // Set the background color to green
                                ),
                                onPressed: () {
                                  // Remove bookmark
                                  PostBookmark.removeBookmark(
                                          houseId: house.houseId)
                                      .then((_) {
                                    log("Bookmark removed successfully.");

                                    if (mounted) {
                                      // Update the bookmarked houses and show a success alert
                                      setState(() {
                                        _bookmarkedHousesFuture =
                                            fetchBookmarkedHouses();
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Bookmark Removed'),
                                            content: const Text(
                                                'This house has been removed from your bookmarks.'),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all<
                                                                Color>(
                                                            const Color(
                                                                0xFF186E1B))),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }).catchError((error) {
                                    log("Error occurred while removing bookmark: $error");
                                  });
                                },
                                child: const Text(
                                  "Bookmarked",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No bookmarked houses.'));
          }
        },
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
