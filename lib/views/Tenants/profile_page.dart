import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _RentingPageState();
}

class _RentingPageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile Page'),
        leading: Container(),
      ),
      body: const Center(
        child: Text('profile page'),
      ),
    );
  }
}

