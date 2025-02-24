import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/services/get_amenities.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/bookmark_page.dart';
import 'package:homi_2/views/Tenants/house_details_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAllHouses();
    _fetchAmenities();
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

  Future<void> _fetchAmenities() async {
    try {
      amenities = await fetchAmenities();
      setState(() {
        isLoadingAmenities = false;
      });
    } catch (e) {
      log('Error fetching amenities: $e');
      setState(() {
        isLoadingAmenities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: Container(
          //   child: Image.asset(
          //     'assets/images/splash.jpeg',
          //   ),
          // ),
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
              icon: const Icon(Icons.bookmark_added),
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: displayedHouses.isEmpty
                      ? const Center(child: Text('No houses found.'))
                      : ListView.builder(
                          itemCount: displayedHouses.length,
                          itemBuilder: (context, index) {
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
