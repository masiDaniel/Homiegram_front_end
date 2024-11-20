// import 'package:flutter/material.dart';
// import 'package:homi_2/models/amenities.dart';
// import 'package:homi_2/models/bookmark.dart';
// import 'package:homi_2/models/get_house.dart';
// import 'package:homi_2/services/get_amenities.dart';
// import 'package:homi_2/services/get_house_service.dart';
// import 'package:homi_2/services/user_sigin_service.dart';
// import 'package:homi_2/views/Tenants/house_details_screen.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   List<GetHouse> allHouses = [];
//   List<GetHouse> displayedHouses = [];
//   String _selectedLocation = 'All Locations';
//   double _minPrice = 0;
//   double _maxPrice = 1000;
//   final List<String> _selectedAmenities = [];
//   Map<int, bool> bookmarkedHouses = {}; // Bookmark tracking map

//   // Sample data for filter chips
//   final List<String> locations = ['All Locations', 'City Center', 'Suburbs'];
//   final List<double> priceRanges = [0, 500, 1000]; // Example price ranges
//   List<Amenities> amenities = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadAllHouses(); // Fetch and display all houses initially
//     fetchAmenitiesforSearching();
//   }

//   Future<void> fetchAmenitiesforSearching() async {
//     try {
//       amenities = await fetchAllAmenities();
//       setState(() {}); // Update the UI with the fetched amenities
//     } catch (e) {
//       print('Error fetching amenities: $e'); // Handle errors appropriately
//     }
//   }

//   Future<void> _loadAllHouses() async {
//     List<GetHouse> fetchedHouses = await fetchHouses();
//     setState(() {
//       allHouses = fetchedHouses;
//       displayedHouses = fetchedHouses; // Initially display all houses
//     });
//   }

//   void _applyFilters() {
//     setState(() {
//       displayedHouses = allHouses.where((house) {
//         bool matchesLocation = _selectedLocation == 'All Locations' ||
//             house.location == _selectedLocation;

//         // Convert rent_amount to double for numeric comparison
//         double? rentAmount = double.tryParse(house.rent_amount);
//         bool matchesPrice = rentAmount! >= _minPrice && rentAmount <= _maxPrice;
//         bool matchesAmenities = _selectedAmenities
//             .every((amenity) => house.amenities.contains(amenity));
//         return matchesLocation && matchesPrice && matchesAmenities;
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Container(),
//         title: TextField(
//           decoration: const InputDecoration(hintText: 'Search houses...'),
//           onChanged: (query) {
//             setState(() {
//               displayedHouses = allHouses
//                   .where((house) =>
//                       house.name.toLowerCase().contains(query.toLowerCase()))
//                   .toList();
//             });
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           // Filter Chips for Location, Price Range, and Amenities
//           Wrap(
//             spacing: 8.0,
//             children: [
//               // Location filter chips
//               ...locations.map((location) {
//                 return FilterChip(
//                   label: Text(location),
//                   selected: _selectedLocation == location,
//                   onSelected: (isSelected) {
//                     setState(() {
//                       _selectedLocation =
//                           isSelected ? location : 'All Locations';
//                       _applyFilters();
//                     });
//                   },
//                 );
//               }).toList(),

//               // Price range filter chips
//               ...priceRanges.map((price) {
//                 return FilterChip(
//                   label: Text('\$${price.toInt()}'),
//                   selected: _minPrice == price,
//                   onSelected: (isSelected) {
//                     setState(() {
//                       if (isSelected) {
//                         _minPrice = price;
//                         _maxPrice = price + 500;
//                       } else {
//                         _minPrice = 0;
//                         _maxPrice = 1000;
//                       }
//                       _applyFilters();
//                     });
//                   },
//                 );
//               }).toList(),

//               // Amenities filter chips
//               ...amenities.map((amenity) {
//                 return FilterChip(
//                   label: Text(amenity.name!),
//                   selected: _selectedAmenities.contains(amenity),
//                   onSelected: (isSelected) {
//                     setState(() {
//                       if (isSelected) {
//                         _selectedAmenities.add(amenity.name!);
//                       } else {
//                         _selectedAmenities.remove(amenity);
//                       }
//                       _applyFilters();
//                     });
//                   },
//                 );
//               }).toList(),
//             ],
//           ),

//           // List of filtered houses
//           Expanded(
//             child: ListView.builder(
//               itemCount: displayedHouses.length,
//               itemBuilder: (context, index) {
//                 final house = displayedHouses[index];
//                 bool isBookmarked = bookmarkedHouses[house.HouseId] ?? false;

//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 8.0, horizontal: 10.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               SpecificHouseDetailsScreen(house: house),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Display the first image for the house
//                         if (house.images!.isNotEmpty)
//                           Image.network(
//                             '$azurebaseUrl${house.images?[0]}', // Use the correct image URL
//                             height: 150,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(
//                               Icons.error,
//                               color: Colors.red,
//                               size: 50,
//                             ),
//                           ),
//                         if (house.images!.isEmpty)
//                           const Placeholder(
//                             fallbackHeight: 150,
//                             fallbackWidth: double.infinity,
//                           ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             house.name,
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text("Location: ${house.location}"),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text("Rent: ${house.rent_amount}"),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text("Rating: ${house.rating}"),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8.0, vertical: 10.0),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               int houseId = house.HouseId; // Get the house ID
//                               PostBookmark.postBookmark(houseId: houseId)
//                                   .then((_) {
//                                 print("Bookmarking action completed.");
//                                 setState(() {
//                                   bookmarkedHouses[houseId] =
//                                       true; // Update bookmark status
//                                 });
//                               }).catchError((error) {
//                                 print(
//                                     "Error occurred while bookmarking: $error");
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: isBookmarked
//                                   ? Colors.green
//                                   : null, // Change button color based on state
//                             ),
//                             child:
//                                 Text(isBookmarked ? 'Bookmarked' : 'Bookmark'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/models/get_house.dart';
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
  String _selectedLocation = 'All Locations';
  double _minPrice = 0;
  double _maxPrice = 1000;
  final List<String> _selectedAmenities = [];
  List<Amenities> amenities = [];
  bool isLoadingAmenities = true;

  @override
  void initState() {
    super.initState();
    _loadAllHouses(); // Fetch and display all houses initially
    fetchAmenitiesforSearching();
  }

  Future<void> fetchAmenitiesforSearching() async {
    try {
      amenities = await fetchAllAmenities();
      setState(() {
        isLoadingAmenities = false; // Set loading to false after fetching
      });
    } catch (e) {
      print('Error fetching amenities: $e');
      setState(() {
        isLoadingAmenities = false; // Set loading to false on error
      });
    }
  }

  Future<void> _loadAllHouses() async {
    List<GetHouse> fetchedHouses = await fetchHouses();
    setState(() {
      allHouses = fetchedHouses;
      displayedHouses = fetchedHouses; // Initially display all houses
    });
  }

  void _applyFilters() {
    setState(() {
      displayedHouses = allHouses.where((house) {
        bool matchesLocation = _selectedLocation == 'All Locations' ||
            house.location == _selectedLocation;

        // Convert rent_amount to double for numeric comparison
        double? rentAmount = double.tryParse(house.rent_amount);
        bool matchesPrice = rentAmount != null &&
            rentAmount >= _minPrice &&
            rentAmount <= _maxPrice;

        bool matchesAmenities = _selectedAmenities.isEmpty ||
            _selectedAmenities
                .every((amenity) => house.amenities.contains(amenity));

        return matchesLocation && matchesPrice && matchesAmenities;
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
      body: Column(
        children: [
          // Filter Chips for Location, Price Range, and Amenities
          Wrap(
            spacing: 8.0,
            children: [
              // Location filter chips
              ...['All Locations', 'City Center', 'Suburbs'].map((location) {
                return FilterChip(
                  label: Text(location),
                  selected: _selectedLocation == location,
                  onSelected: (isSelected) {
                    setState(() {
                      _selectedLocation =
                          isSelected ? location : 'All Locations';
                      _applyFilters();
                    });
                  },
                );
              }).toList(),

// Price range filter chips
              ...[0, 500, 1000].map((price) {
                return FilterChip(
                  label: Text('\$${price.toInt()}'),
                  selected: _minPrice == price.toDouble(),
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _minPrice = price.toDouble();
                        _maxPrice = (price + 500).toDouble();
                      } else {
                        _minPrice = 0;
                        _maxPrice = 1000;
                      }
                      _applyFilters();
                    });
                  },
                );
              }).toList(),

              // Amenities filter chips
              if (isLoadingAmenities)
                const CircularProgressIndicator() // Show loading indicator while fetching amenities
              else
                ...amenities.map((amenity) {
                  return FilterChip(
                    label: Text(
                        amenity.name ?? 'Unknown'), // Ensure non-null label
                    selected: _selectedAmenities.contains(amenity.name),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedAmenities.add(amenity.name!);
                        } else {
                          _selectedAmenities.remove(amenity.name!);
                        }
                        _applyFilters();
                      });
                    },
                  );
                }).toList(),
            ],
          ),

          // List of filtered houses
          Expanded(
            child: ListView.builder(
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
                              SpecificHouseDetailsScreen(house: house),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (house.images?.isNotEmpty ?? false)
                          Image.network(
                            '$devUrl${house.images?.first}', // Use the correct image URL
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        if (house.images?.isEmpty ?? true)
                          const Placeholder(
                            fallbackHeight: 150,
                            fallbackWidth: double.infinity,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            house.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Location: ${house.location}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Rent: ${house.rent_amount}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
