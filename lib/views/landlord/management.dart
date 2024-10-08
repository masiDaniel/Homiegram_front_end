import 'package:flutter/material.dart';

class LandordManagement extends StatefulWidget {
  const LandordManagement({super.key});

  @override
  State<LandordManagement> createState() => _LandordManagementState();
}

class _LandordManagementState extends State<LandordManagement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('this is the landlord'),
    );
  }
}
