import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/services/get_amenities.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
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

  String _selectedLocation = 'All Locations';
  final List<String> _selectedAmenities = [];

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
      print('Error fetching houses: $e');
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
      print('Error fetching amenities: $e');
      setState(() {
        isLoadingAmenities = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      displayedHouses = allHouses.where((house) {
        // Location filter
        bool matchesLocation = _selectedLocation == 'All Locations' ||
            house.location == _selectedLocation;

        // Amenities filter
        bool matchesAmenities = _selectedAmenities.isEmpty ||
            _selectedAmenities
                .every((amenity) => house.amenities.contains(amenity));

        return matchesLocation && matchesAmenities;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: TextField(
          decoration: const InputDecoration(hintText: 'Search houses...'),
          onChanged: (query) {
            setState(() {
              displayedHouses = allHouses
                  .where((house) =>
                      house.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          },
        ),
      ),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        house.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child:
                                          Text("Location: ${house.location}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text("Rent: ${house.rent_amount}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text("Rating: ${house.rating}"),
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
