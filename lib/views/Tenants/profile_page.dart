import 'package:flutter/material.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/services/user_signout_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  void _showEditDialog() {
    // final TextEditingController idController =
    //     TextEditingController(text: userId);
    // final TextEditingController phoneController =
    //     TextEditingController(text: phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  // controller: idController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
                TextField(
                  // controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  // userId = idController.text; // Update user ID
                  // phoneNumber = phoneController.text; // Update phone number
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        leading: Container(),
        backgroundColor: const Color(0xFF126E06),
        actions: [
          IconButton(
              onPressed: () {
                _showEditDialog();
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                // Implement profile picture selection
                final ImagePicker picker = ImagePicker();
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    imageUrl = pickedFile
                        .path; // Update imageUrl with the selected image path
                  });
                }
              },
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 2, 75, 50),
                radius: 60,
                backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage('$azurebaseUrl$imageUrl')
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
                    leading: const Icon(Icons.person, color: Color(0xFF126E06)),
                    title: const Text('User ID'),
                    subtitle: Text('$userId'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_circle,
                        color: Color(0xFF126E06)),
                    title: const Text('Username'),
                    subtitle: Text('$userName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: Color(0xFF126E06)),
                    title: const Text('First Name'),
                    subtitle: Text('$firstName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: Color(0xFF126E06)),
                    title: const Text('Last Name'),
                    subtitle: Text('$lastName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Color(0xFF126E06)),
                    title: const Text('Email'),
                    subtitle: Text('$userEmail'),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.credit_card, color: Color(0xFF126E06)),
                    title: const Text('ID Number'),
                    subtitle: Text('$idNumber'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF126E06)),
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
