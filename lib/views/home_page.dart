import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/section_headers_homepage_view.dart';
import 'package:homi_2/views/student_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// get this into a seperate function that can be used in differenet files
String _extractInitials(String name) {
  List<String> nameParts = name.split(' ');
  if (nameParts.isNotEmpty) {
    return nameParts[0][0].toUpperCase(); // First letter of the first name
  } else {
    return ''; // Return empty string if name is empty
  }
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<GetHouse>> futureHouses;
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
  final List<String> _amenities = [
    'Swimming pool',
    'Wi-Fi',
    'Vet',
    'Generator'
  ];

  @override
  void initState() {
    super.initState();
    futureHouses = fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const studentDashboardView()),
                      );
                    },
                    child: CircleAvatar(
                      foregroundImage: imageUrl != null
                          ? NetworkImage('$baseUrl$imageUrl')
                          : null,
                      backgroundColor: const Color.fromARGB(255, 3, 101, 139),
                      child: imageUrl != null
                          ? null
                          : Text(
                              _extractInitials('$firstName'),
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Welcome back, $firstName",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: myTextField(
                    controller: _searchController,
                    hintText: "Search",
                    obscureText: false,
                    suffixIcon: Icons.search,
                    onChanged: (value) {
                      setState(() {});
                    }),
              ),
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
                                color: Color.fromARGB(255, 6, 6, 6),
                                fontSize: 12,
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
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RangeSlider(
                              values: RangeValues(_minPrice, _maxPrice),
                              max: 100000,
                              divisions: 100,
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
                        color: Color.fromARGB(255, 6, 6, 6),
                        fontSize: 12,
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
                        onPressed: () {},
                        width: 100,
                        height: 50,
                        color: const Color.fromARGB(255, 2, 2, 2),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 25,
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
            ],
          ),
        ),
      ),
    );
  }
}
