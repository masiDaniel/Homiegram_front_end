import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';

import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';

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

  // String _searchQuery = '';

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
                      backgroundColor: Colors.purpleAccent,
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
                    "Price",
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
              // const Divider(
              //   height: 1.0,
              //   thickness: 1.0,
              //   color: Colors.black,
              // ),
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
              const sectionHeders(),
            ],
          ),
        ),
      ),
    );
  }
}

class sectionHeders extends StatelessWidget {
  final String headerTitle;

  const sectionHeders({super.key, this.headerTitle = "homie Houses"});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Text(
                headerTitle,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  print("button clicked");
                },
                icon: const Icon(
                  Icons.more_horiz,
                  size: 28,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const HousesView(),
      ],
    );
  }
}

class HousesView extends StatelessWidget {
  const HousesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 25.0,
          ),
          InkWell(
            onTap: () async {
              final house = await fetchHouses();
              print(house);
              if (house != null) {
                Navigator.pushNamed(context, '/specific', arguments: house);
              } else {
                print("first house not accessed");
              }
            },
            child: Container(
              height: 240,
              width: 380,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/1_1.jpeg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/allHouses');
            },
            child: Container(
              height: 240,
              width: 380,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/1_2.jpeg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/trialAllHouses');
            },
            child: Container(
              height: 240,
              width: 380,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/1_3.jpeg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          InkWell(
            onTap: () {
              print("fourth house");
            },
            child: Container(
              height: 240,
              width: 380,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/1_4.jpeg'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
        ],
      ),
    );
  }
}
