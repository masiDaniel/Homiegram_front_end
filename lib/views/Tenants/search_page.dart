import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/get_amenities.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/views/Tenants/section_headers_homepage_view.dart';
import 'package:http/http.dart' as http;

///
///how will i handle having multiple arguments to pass to a url, ie searching
///and filtering
///
///

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<GetHouse> searchTerms = AllHouses;

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<GetHouse> matchQuery = [];
    for (var house in searchTerms) {
      if (house.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(house);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<GetHouse> matchQuery = [];
    for (var house in searchTerms) {
      if (house.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(house);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
        );
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<GetHouse>> futureHouses;
  late Future<List<Amenities>> futureAmenities;
  String _selectedLocation = 'All Locations';
  final List<String> _locations = [
    'All Locations',
    'Devki',
    'Nairobi - CBD',
    'Machakos'
  ];

  final double _minPrice = 0;
  double _maxPrice = 1000;
  final List<String> _selectedAmenities = [];
  final List<String> _amenities = [];

  @override
  void initState() {
    super.initState();
    futureHouses = fetchHouses();
    futureAmenities = fetchAllAmenities();
  }

  Map<String, dynamic> _getFilterData() {
    return {
      'location': _selectedLocation,
      'min_price': _minPrice,
      'max_price': _maxPrice,
      'amenities': _selectedAmenities,
    };
  }

  Future<List<GetHouse>> fetchFilteredHouses() async {
    String baseUrl = 'http://127.0.0.1:8000';
    String apiUrl = '$baseUrl/api/houses/filter';

    // Prepare the filter parameters
    Map<String, dynamic> filterParams = {
      'location': _selectedLocation,
      'min_price': _minPrice,
      'max_price': _maxPrice,
      'amenities': _selectedAmenities,
    };

    // Send the request to the API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(filterParams),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => GetHouse.fromJSon(data)).toList();
    } else {
      throw Exception('Failed to load houses');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("these are the amenities ${futureAmenities}");
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width:
                          150.0, // Set the desired width and height (equal for a circle)
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: const Color(
                              0xFF126E06), // Set the background color
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.circular(16) // Circular shape
                          ),
                      child: IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(),
                          );
                        },
                        icon: Icon(Icons.search,
                            color: Colors.white), // Set icon color if needed
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    spacing: 10, // Space between adjacent chips.
                    runSpacing: 10, // Space between lines.
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "location",
                                style: TextStyle(
                                  color: const Color(0xFF126E06),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DropdownButton<String>(
                                borderRadius: BorderRadius.circular(20),
                                padding: EdgeInsets.all(10),
                                value: _selectedLocation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedLocation = newValue!;
                                  });
                                },
                                items: _locations.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Price",
                                style: TextStyle(
                                  color: const Color(0xFF126E06),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RangeSlider(
                                values: RangeValues(_minPrice, _maxPrice),
                                max: 100000,
                                divisions: 100,
                                activeColor: Color(0xFF126E06),
                                labels: RangeLabels(
                                    '\Ksh $_minPrice', '\Ksh $_maxPrice'),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    // _minPrice = values.start;
                                    _maxPrice = values.end;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        "Amenities",
                        style: TextStyle(
                          color: const Color(0xFF126E06),
                          fontSize: 16,
                        ),
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _amenities.map((String amenity) {
                          return CheckboxListTile(
                            title: Text(amenity),
                            value: _selectedAmenities.contains(amenity),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  _selectedAmenities.add(amenity);
                                } else {
                                  _selectedAmenities.remove(amenity);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MyButton(
                          buttonText: "apply",
                          onPressed: () async {
                            // Fetch the filtered houses
                            List<GetHouse> filteredHouses =
                                await fetchFilteredHouses();

                            setState(() {
                              futureHouses = Future.value(filteredHouses);
                            });
                          },
                          width: 100,
                          height: 50,
                          color: const Color(0xFF126E06),
                        ),
                      ]),
                ),
                const sectionHeders(
                  headerTitle: "Highlights",
                ),
                const sectionHeders(
                  headerTitle: "all houses",
                ),
                const SizedBox(
                  height: 25,
                ),
                const sectionHeders(
                  headerTitle: "house listings",
                ),
              ]),
        ),
      ),
    );
  }
}
