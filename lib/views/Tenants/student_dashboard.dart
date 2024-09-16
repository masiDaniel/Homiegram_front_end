import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/services/user_signout_service.dart';

class studentDashboardView extends StatefulWidget {
  ///
  ///this page handles the page for the specific user
  ///it will contain the users name, profile, bookmarks and current residence(this should be handled by 10th may)
  ///it will have a log out button
  ///

  const studentDashboardView({super.key});

  @override
  State<studentDashboardView> createState() => _studentDashboardViewState();
}

class _studentDashboardViewState extends State<studentDashboardView> {
  //this is a method that calls the logoutUser method and if it is succesfull it redirectts the user to the homepage
  Future<void> _logout() async {
    try {
      await logoutUser();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print("error logging out: $e");
    }
  }

  // this is a function that takes the first letter from the name of the user
  String _extractInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase(); //first name, first letter
    } else {
      return 'HG'; // Return Homiegram initials if name is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            // Your container properties here
            child: const Text(
              'Go Back',
              style: TextStyle(fontSize: 15),
            ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 2, 75, 50),
                          maxRadius: 25,
                          backgroundImage: imageUrl != null
                              ? NetworkImage('$baseUrl$imageUrl')
                              : null,
                          child: imageUrl == null
                              ? Text(
                                  _extractInitials('$firstName'),
                                  style: TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'hi, $firstName\n Today is  ${DateTime.now().toString().substring(0, 10)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Your rent is due in, $firstName days',
                    style: const TextStyle(fontSize: 20),
                  ),
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
