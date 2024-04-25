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

String _extractInitials(String name) {
  List<String> nameParts = name.split(' ');
  if (nameParts.isNotEmpty) {
    return nameParts[0][0]; // First letter of the first name
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
    'Location 1',
    'Location 2',
    'Location 3'
  ];

  double _minPrice = 0;
  double _maxPrice = 1000;
  final List<String> _selectedAmenities = [];
  final List<String> _amenities = ['Amenity 1', 'Amenity 2', 'Amenity 3'];

  @override
  void initState() {
    super.initState();
    futureHouses = fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController searchController = TextEditingController();
    String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 255, 255),
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
                      foregroundImage: ImageUrl != null
                          ? NetworkImage('$baseUrl$ImageUrl')
                          : null,
                      backgroundColor: Color.fromARGB(255, 3, 101, 139),
                      child: ImageUrl != null
                          ? null
                          : Text(
                              _extractInitials('$firstName'),
                              style: TextStyle(color: Colors.white),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "location",
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 6, 6),
                      fontSize: 12,
                    ),
                  ),
                  Flexible(
                    child: DropdownButton<String>(
                      value: _selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue!;
                        });
                      },
                      items: _locations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Price",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    labels: RangeLabels('\$$_minPrice', '\$$_maxPrice'),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  const Text(
                    "Rooms",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      print("button clicked");
                    },
                    icon: const Icon(
                      Icons.arrow_downward_sharp,
                      size: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Amenities",
                    style: TextStyle(
                      color: Color.fromARGB(255, 6, 6, 6),
                      fontSize: 12,
                    ),
                  ),
                  Column(
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
                        color: Color.fromARGB(255, 2, 2, 2),
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
                headerTitle: "best ranked",
              ),
              const SizedBox(
                height: 25,
              ),
              const sectionHeders(
                headerTitle: "most viewed",
              ),
              const SizedBox(
                height: 25,
              ),
              const sectionHeders(
                headerTitle: "closest to you",
              ),
              const SizedBox(
                height: 25,
              ),
              const sectionHeders(),
              const SizedBox(
                height: 25,
              ),
              const sectionHeders(),
              const SizedBox(
                height: 25,
              ),
              const sectionHeders(),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
