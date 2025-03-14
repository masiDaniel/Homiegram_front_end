import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:homi_2/services/user_signout_service.dart';

class StudentDashboardView extends StatefulWidget {
  ///
  ///this page handles the page for the specific user
  ///it will contain the users name, profile, bookmarks and current residence(this should be handled by 10th may)
  ///it will have a log out button
  ///

  const StudentDashboardView({super.key});

  @override
  State<StudentDashboardView> createState() => StudentDashboardViewState();
}

class StudentDashboardViewState extends State<StudentDashboardView> {
  //this is a method that calls the logoutUser method and if it is succesfull it redirectts the user to the homepage
  Future<void> _logout() async {
    try {
      await logoutUser();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      log("error logging out: $e");
    }
  }

  // this is a function that takes the first letter from the name of the user
  String extractInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase(); //first name, first letter
    } else {
      return 'HG'; // Return Homiegram initials if name is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Go Back',
            style: TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          Tooltip(
              message: 'Log Out',
              child: IconButton(
                  onPressed: _logout, icon: const Icon(Icons.logout)))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // CircleAvatar(
                        //   backgroundColor: const Color.fromARGB(255, 2, 75, 50),
                        //   maxRadius: 25,
                        //   backgroundImage: imageUrl != null
                        //       ? NetworkImage('$devUrl$imageUrl')
                        //       : null,
                        //   child: imageUrl == null
                        //       ? Text(
                        //           extractInitials('$firstName'),
                        //           style: const TextStyle(color: Colors.white),
                        //         )
                        //       : null,
                        // ),
                        SizedBox(
                          width: 20,
                        ),
                        // Text(
                        //   'hi, $firstName\n Today is  ${DateTime.now().toString().substring(0, 10)}',
                        //   style: const TextStyle(fontSize: 20),
                        // ),
                      ],
                    ),
                  ),
                  // Text(
                  //   'Your rent is due in, $firstName days',
                  //   style: const TextStyle(fontSize: 20),
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(children: <Widget>[
                          const Text(
                            'Current House',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF126E06),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 240,
                            width: 380,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.asset(
                                'assets/images/1_1.jpeg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xFF126E06),
                    thickness: 3,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text(
                    'Bookmarks',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF126E06)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset('assets/images/1_1.jpeg')),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset('assets/images/1_2.jpeg')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
