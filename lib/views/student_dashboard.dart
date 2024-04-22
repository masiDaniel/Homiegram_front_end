import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            // Your container properties here
            child: const Text('Go Back'),
          ),
        ),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Current House',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset('assets/images/1_1.jpeg'),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const Text(
                    'Bookmarks',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset('assets/images/1_1.jpeg'),
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
