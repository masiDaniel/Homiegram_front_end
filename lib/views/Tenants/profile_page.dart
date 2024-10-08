import 'package:flutter/material.dart';
import 'package:homi_2/services/user_sigin_service.dart';

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

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('profile Page'),
  //       leading: Container(),
  //     ),
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Row(
  //           children: [
  //             SizedBox(
  //               height: 200,
  //               child: CircleAvatar(
  //                 backgroundColor: const Color.fromARGB(255, 2, 75, 50),
  //                 maxRadius: 150,
  //                 backgroundImage: imageUrl != null
  //                     ? NetworkImage('$baseUrl$imageUrl')
  //                     : null,
  //                 child: imageUrl == null
  //                     ? Text(
  //                         extractInitials('$firstName'),
  //                         style: const TextStyle(color: Colors.white),
  //                       )
  //                     : null,
  //               ),
  //             ),
  //             Column(
  //               children: [
  //                 Text('User Id: $userId'),
  //                 Text('Username: $userName'),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
        leading: Container(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
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
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'User ID: $userId',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'Username: $userName',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'First Name: $firstName',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'Last Name: $lastName',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'Email: $userEmail',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'ID Number: $idNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, color: Colors.teal),
                      const SizedBox(width: 10),
                      Text(
                        'PhoneNumber: $phoneNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
