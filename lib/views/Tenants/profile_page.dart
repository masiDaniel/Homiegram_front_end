import 'package:flutter/material.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _RentingPageState();
}

class _RentingPageState extends State<ProfilePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile Page'),
        leading: Container(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 2, 75, 50),
              maxRadius: 150,
              backgroundImage:
                  imageUrl != null ? NetworkImage('$baseUrl$imageUrl') : null,
              child: imageUrl == null
                  ? Text(
                      extractInitials('$firstName'),
                      style: TextStyle(color: Colors.white),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
