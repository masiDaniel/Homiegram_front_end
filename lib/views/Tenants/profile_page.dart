import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homi_2/components/my_snackbar.dart';
import 'package:homi_2/services/theme_provider.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/services/user_signout_service.dart';
import 'package:homi_2/views/Shared/bookmark_page.dart';
import 'package:homi_2/views/Shared/edit_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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

  String extractInitials(String name) {
    if (name.isEmpty) {
      return 'HG';
    }
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    } else {
      return 'HG';
    }
  }

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
    });
  }

  Future<void> _logout() async {
    try {
      await logoutUser();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userType');

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      log("Error logging out: $e");
    }
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
      if (!mounted) return;
      showCustomSnackBar(context, "Failed to select image. Try again later");
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
    const defaultImage1 = AssetImage('assets/images/default_avatar.jpeg');

    if (profilePicture == null ||
        profilePicture.isEmpty ||
        profilePicture == "N/A") {
      return null;
    }

    if (profilePicture.startsWith("/media/")) {
      return NetworkImage('$devUrl$profilePicture');
    }

    final file = File(profilePicture);
    if (file.existsSync()) {
      return FileImage(file);
    }

    return defaultImage1;
  }

  @override
  Widget build(BuildContext context) {
    bool showInitials = currentUserProfilePicture == "N/A";
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

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
              )),
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
                    onTap: () {},
                    child: const ListTile(
                      leading:
                          Icon(Icons.money_off_sharp, color: Color(0xFF126E06)),
                      title: Text('Purchases'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Theme'),
                    trailing: Switch(
                      // have this to be stateful
                      value: isDark,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                      activeThumbColor: const Color(0xFF126E06),
                      activeTrackColor: Colors.green[200],
                      inactiveThumbColor: const Color(0xFF126E06),
                      inactiveTrackColor: Colors.white,
                    ),
                  )
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
                  Navigator.of(context).pop();
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
