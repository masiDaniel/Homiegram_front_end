import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/services/user_signout_service.dart';
import 'package:homi_2/views/Shared/bookmark_page.dart';
import 'package:homi_2/views/Shared/edit_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? currentUserType;
  int? currentUserId;
  String? currentUserFirstName;
  String? currentUserName;
  String? currentUserLastName;
  String? currentUserEmail;
  int? currentserIdNumber;
  String? currentUserPhoneNumber;
  String? currentUserProfilePicture;
  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  // this is a function that takes the first letter from the name of the user
  String extractInitials(String name) {
    if (name.isEmpty) {
      return 'HG'; // Default to Homigram initials if name is empty
    }
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase(); //first name, first letter
    } else {
      return 'HG'; // Return Homiegram initials if name is empty
    }
  }

  // Future<void> debugSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print('Stored Last Name: ${prefs.getString('lastName')}');
  //   print('Stored Email: ${prefs.getString('userEmail')}');
  //   print('Stored ID Number: ${prefs.getInt('idNumber')}');
  //   print('Stored Phone Number: ${prefs.getString('phoneNumber')}');
  //   print('Stored profile photo: ${prefs.getString('profilePicture')}');
  // }

  Future<void> loadUserId() async {
    int? id = await UserPreferences.getUserId();
    String? type = await UserPreferences.getUserType();
    String? firstName = await UserPreferences.getFirstName();
    String? userName = await UserPreferences.getUserName();
    String? lastName = await UserPreferences.getLastName();
    String? email = await UserPreferences.getUserEmail();
    String? phoneNumber = await UserPreferences.getPhoneNumber();
    int? idNumber = await UserPreferences.getIdNumber();
    String? profilePicture = await UserPreferences.getProfilePicture();

    setState(() {
      currentUserId = id;
      currentUserType = type;
      currentUserFirstName = firstName;
      currentUserName = userName;
      currentUserLastName = lastName;
      currentUserEmail = email;
      currentUserPhoneNumber = phoneNumber;
      currentserIdNumber = idNumber;
      currentUserProfilePicture = profilePicture;
      print("this is the current picture ${currentUserProfilePicture}");
    });
  }

  Future<void> _logout() async {
    try {
      await logoutUser(); // Your existing logout logic

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn'); // Remove login flag
      await prefs.remove('userType'); // Remove user type

      if (!mounted) return; // Ensure the widget is still mounted

      Navigator.pushReplacementNamed(
          context, '/'); // Navigate to the welcome screen
    } catch (e) {
      log("Error logging out: $e");
    }
  }

  void _showEditDialog() {
    final TextEditingController idNumberController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: idNumberController,
                  decoration: const InputDecoration(labelText: 'National ID'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
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
              onPressed: () async {
                // Collect the updated fields
                Map<String, dynamic> updateData = {};

                if (idNumberController.text.isNotEmpty) {
                  updateData['id_number'] = idNumberController.text;
                }
                if (phoneController.text.isNotEmpty) {
                  updateData['phone_number'] = phoneController.text;
                }

                if (updateData.isNotEmpty) {
                  // Call the backend update function
                  bool? success = await updateUserInfo(updateData);
                  if (success == true) {
                    log('Profile updated successfully!');
                  } else {
                    log('Failed to update profile.');
                  }
                }

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          currentUserProfilePicture = pickedFile.path;
        });

        // Show confirmation dialog
        final bool? confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update Profile Picture'),
              content:
                  const Text('Do you want to update your profile picture?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          await updateProfilePicture(currentUserProfilePicture!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to select image. Please try again."),
        ),
      );
    }
  }

  void showFullImage() {
    if (currentUserProfilePicture != null &&
        currentUserProfilePicture!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child:
              Image(image: NetworkImage(('$devUrl$currentUserProfilePicture'))),
        ),
      );
    }
  }

  ImageProvider<Object>? getProfileImage(
      String? profilePicture, String devUrl) {
    // Default fallback image
    const defaultImage1 = AssetImage('assets/images/default_avatar.jpeg');
    const defaultImage = AssetImage('assets/images/1_3.jpeg');
    const splashImage = AssetImage('assets/images/splash.jpeg');

    // If profile picture is missing or set to "homigram", return splash image
    if (profilePicture == null ||
        profilePicture.isEmpty ||
        profilePicture == "N/A") {
      return null;
    }

    // If stored profile picture follows "/media/photo.jpeg" format, attach devUrl
    if (profilePicture.startsWith("/media/")) {
      return NetworkImage('$devUrl$profilePicture');
    }

    // If the stored profile picture is a valid local file, return it
    final file = File(profilePicture);
    if (file.existsSync()) {
      return FileImage(file);
    }

    // If nothing works, return the default avatar
    return defaultImage1;
  }

  @override
  Widget build(BuildContext context) {
    bool showInitials = currentUserProfilePicture == "N/A";
    print("this is the current user profile ${currentUserProfilePicture}");

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
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit_attributes_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 2, 75, 50),
                    radius: 60,
                    backgroundImage:
                        getProfileImage(currentUserProfilePicture, devUrl),
                    child: showInitials
                        ? Text(
                            extractInitials(currentUserFirstName ?? ''),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ],
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
                  // ListTile(
                  //   leading: const Icon(Icons.person, color: Color(0xFF126E06)),
                  //   title: const Text('User ID'),
                  //   subtitle: Text('$currentUserId'),
                  // ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_circle,
                        color: Color(0xFF126E06)),
                    title: const Text('Username'),
                    subtitle: Text('$currentUserName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: Color(0xFF126E06)),
                    title: const Text('First Name'),
                    subtitle: Text('$currentUserFirstName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: Color(0xFF126E06)),
                    title: const Text('Last Name'),
                    subtitle: Text('$currentUserLastName'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Color(0xFF126E06)),
                    title: const Text('Email'),
                    subtitle: Text('$currentUserEmail'),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.credit_card, color: Color(0xFF126E06)),
                    title: const Text('ID Number'),
                    subtitle: Text('$currentserIdNumber'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF126E06)),
                    title: const Text('Phone Number'),
                    subtitle: Text('$currentUserPhoneNumber'),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookmarkedHousesPage(
                            userId: currentUserId!,
                          ),
                        ),
                      );
                    },
                    child: const ListTile(
                      leading: Icon(Icons.bookmark_add_outlined,
                          color: Color(0xFF126E06)),
                      title: Text('bookmarks'),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BookmarkedHousesPage(
                      //       userId: currentUserId!,
                      //     ),
                      //   ),
                      // );
                    },
                    child: const ListTile(
                      leading:
                          Icon(Icons.money_off_sharp, color: Color(0xFF126E06)),
                      title: Text('Purchases'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (currentUserType != "landlord")
            ElevatedButton.icon(
              onPressed: () async {
                Map<String, dynamic> updateData = {};
                updateData['user_type'] = 'landlord';
                bool? success = await updateUserInfo(updateData);
                if (success == true) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset('assets/animations/fix.json',
                              width: 200, height: 200),
                          const SizedBox(height: 20),
                          const Text(
                            "You are now a landlord with us!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.of(context).pop(); // Close the dialog
                  _logout();
                } else {
                  log('Failed to update profile.');
                }
              },
              icon: const Icon(
                Icons.house,
                color: Colors.white,
              ),
              label: const Text(
                'Become a Landlord',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 100, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              _logout();
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
