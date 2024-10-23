import 'package:flutter/material.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/services/user_signout_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String baseUrl = 'http://127.0.0.1:8000';

  // this is a function that takes the first letter from the name of the user
  String extractInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase(); //first name, first letter
    } else {
      return 'HG'; // Return Homiegram initials if name is empty
    }
  }

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
        title: const Text('Profile Page'),
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () {
                // handling of editing of the profile
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                //functionality to update the profile image.
              },
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 2, 75, 50),
                radius: 60,
                backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage('$baseUrl$imageUrl')
                    : null,
                child: imageUrl == null || imageUrl!.isEmpty
                    ? Text(
                        extractInitials(firstName!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.teal),
                    title: const Text('User ID'),
                    subtitle: Text('$userId'),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.account_circle, color: Colors.teal),
                    title: const Text('Username'),
                    subtitle: Text('$userName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.person_outline, color: Colors.teal),
                    title: const Text('First Name'),
                    subtitle: Text('$firstName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.person_outline, color: Colors.teal),
                    title: const Text('Last Name'),
                    subtitle: Text('$lastName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.teal),
                    title: const Text('Email'),
                    subtitle: Text('$userEmail'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.teal),
                    title: const Text('ID Number'),
                    subtitle: Text('$idNumber'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.teal),
                    title: const Text('Phone Number'),
                    subtitle: Text('$phoneNumber'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              // Handle logout functionality
              _logout();
              print('logging out');
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 160, 2, 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
