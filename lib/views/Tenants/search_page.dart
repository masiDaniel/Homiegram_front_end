import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/services/get_amenities.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/bookmark_page.dart';
import 'package:homi_2/views/Tenants/house_details_screen.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<GetHouse> allHouses = [];
  List<GetHouse> displayedHouses = [];
  List<Amenities> amenities = [];
  bool isLoadingHouses = true;
  bool isLoadingAmenities = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadAllHouses();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userId = id;
    });
  }

  Future<void> _loadAllHouses() async {
    try {
      List<GetHouse> fetchedHouses = await fetchHouses();
      setState(() {
        allHouses = fetchedHouses;
        displayedHouses = fetchedHouses;
        isLoadingHouses = false;
      });
    } catch (e) {
      log('Error fetching houses: $e');
      setState(() {
        isLoadingHouses = false;
      });
    }
  }

  // Future<void> _fetchAmenities() async {
  //   try {
  //     amenities = await fetchAmenities();
  //     setState(() {
  //       isLoadingAmenities = false;
  //     });
  //   } catch (e) {
  //     log('Error fetching amenities: $e');
  //     setState(() {
  //       isLoadingAmenities = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Search houses...',
              border: InputBorder.none,
            ),
            onChanged: (query) {
              setState(() {
                displayedHouses = allHouses
                    .where((house) =>
                        house.name.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.bookmark_added,
                color: Color(0xFF126E06),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkedHousesPage(
                      userId: userId!,
                    ),
                  ),
                );
              },
            ),
          ]),
      body: isLoadingHouses
          ? const Center(
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
            ))
          : Column(
              children: [
                Expanded(
                  // create an animation for this
                  child: displayedHouses.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            'assets/animations/notFound.json', // Path to your animation file
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ListView.builder(
                          itemCount: displayedHouses.length,
                          itemBuilder: (context, index) {
                            displayedHouses
                                .sort((a, b) => b.rating.compareTo(a.rating));
                            final house = displayedHouses[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SpecificHouseDetailsScreen(
                                              house: house),
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
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/splash.jpeg',
                                        ),
                                      ),
                                    if (house.images?.isEmpty ?? true)
                                      Image.asset(
                                        'assets/images/splash.jpeg',
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            house.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("Location: ${house.location}"),
                                          const SizedBox(height: 4),
                                          Text("Rent: ${house.rentAmount}"),
                                          const SizedBox(height: 4),
                                          Text("Rating: ${house.rating}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
