import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/services/user_signout_service.dart';

class studentDashboardView extends StatefulWidget {
  ///
  ///this page handles the page for the specific user
  ///it will contain the users name, profile, bookmarks and current residence
  const studentDashboardView({super.key});

  @override
  State<studentDashboardView> createState() => _studentDashboardViewState();
}

class _studentDashboardViewState extends State<studentDashboardView> {
  Future<void> _logout() async {
    try {
      await logoutUser();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print("error logging out: $e");
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
              child: IconButton(onPressed: _logout, icon: Icon(Icons.logout)))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('$baseUrl$ImageUrl'),
                          maxRadius: 25,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          'hi, $firstName',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Column(
                          children: [
                            Text(
                                'Today is \n ${DateTime.now().toString().substring(0, 10)}'),
                          ],
                        ),
                      ],
                    ),
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
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
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
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text(
                    'Bookmarks',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset('assets/images/1_1.jpeg')),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset('assets/images/1_3.jpeg'),
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
