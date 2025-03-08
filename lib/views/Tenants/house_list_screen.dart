import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:homi_2/models/bookmark.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/house_details_screen.dart';

class HouseListScreen extends StatefulWidget {
  const HouseListScreen({super.key});

  @override
  State<HouseListScreen> createState() => HouseListScreenState();
}

class HouseListScreenState extends State<HouseListScreen> {
  late Future<List<GetHouse>> futureHouses;
  // Variable to track if the house is bookmarked
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    futureHouses = fetchHouses();
  }

  // This map will store the bookmark state for each house by its HouseId
  Map<int, bool> bookmarkedHouses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House listings'),
      ),
      body: FutureBuilder(
          future: futureHouses,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    int houseId = snapshot.data![index].houseId;

                    // Check if this house is bookmarked, if not default to false
                    bool isBookmarked = bookmarkedHouses[houseId] ?? false;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificHouseDetailsScreen(
                                house: snapshot.data![index]),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for (var imageUrl in snapshot.data![index].images)
                            if (snapshot.data![index].images!.isNotEmpty)
                              Image.network(
                                '$devUrl${snapshot.data![index].images?[0]}',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                            if (snapshot.data![index].images!.isEmpty)
                              const Placeholder(
                                fallbackHeight: 150,
                                fallbackWidth: double.infinity,
                              ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rent amount: ${snapshot.data![index].rentAmount}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Rating: ${snapshot.data![index].rating}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Location: ${snapshot.data![index].location}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  // Spacer pushes the button to the right
                                  const Spacer(),

                                  ElevatedButton(
                                    onPressed: () {
                                      int houseId = snapshot.data![index]
                                          .houseId; // Replace this with the actual house ID you want to bookmark
                                      PostBookmark.postBookmark(
                                              houseId: houseId)
                                          .then((_) {
                                        // Optionally handle successful bookmarking here, like showing a message to the user

                                        setState(() {
                                          bookmarkedHouses[houseId] = true;
                                        });
                                      }).catchError((error) {
                                        // Handle any errors here
                                        log("Error occurred while bookmarking: $error");
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isBookmarked
                                          ? Colors.green
                                          : null, // Change button color based on state
                                    ),
                                    child: Text(isBookmarked
                                        ? 'Bookmarked'
                                        : 'Bookmark'),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return const Center(
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
            ));
          }),
    );
  }
}
