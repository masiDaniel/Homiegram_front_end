import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:homi_2/models/bookmark.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/fetch_bookmarks.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/house_details_screen.dart';

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
    _bookmarkedHousesFuture = _fetchBookmarkedHouses();
  }

  Future<List<GetHouse>> _fetchBookmarkedHouses() async {
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
            return const Center(child: CircularProgressIndicator());
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
                          child: Text("Location: ${house.location}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Rent: ${house.rentAmount}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Rating: ${house.rating}"),
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
                                            _fetchBookmarkedHouses();
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
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
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
}
