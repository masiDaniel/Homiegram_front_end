import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/get_amenities.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/get_locations.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Shared/bookmark_page.dart';
import 'package:homi_2/views/Shared/house_details_screen.dart';
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
  List<Locations> locations = [];
  bool isLoadingHouses = true;
  bool isLoadingAmenities = true;
  int? userId;
  late Future<List<Locations>> futureLocations;

  @override
  void initState() {
    super.initState();
    _loadAllHouses();
    _loadUserId();
    _fetchLocationsAndAmenities();
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
      if (!mounted) return;
      setState(() {
        isLoadingHouses = false;
      });
    }
  }

  Future<void> _fetchLocationsAndAmenities() async {
    try {
      List<Locations> fetchedLocations = await fetchLocations();
      List<Amenities> fetchedAmenities = await fetchAmenities();

      setState(() {
        locations = fetchedLocations;
        amenities = fetchedAmenities;
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
      ),
    );
    return '${location.area}, ${location.town}, ${location.county}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// TODO: search & Filters: Students can search for rooms based on
      /// - location,
      /// - price range
      /// - available amenities.
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
          scrolledUnderElevation: 0,
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
                  color: Colors.green,
                  strokeWidth: 6.0,
                ),
                SizedBox(height: 10),
                Text("Loading, please wait...",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ))
          : Column(
              children: [
                Expanded(
                  child: displayedHouses.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            'assets/animations/notFound.json',
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
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF126E06)),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("Rent: ${house.rentAmount}"),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Text("Rating:"),
                                              buildSimpleStars(
                                                  house.rating.toDouble()),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              "location: ${getLocationName(house.locationDetail!)}"),
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
