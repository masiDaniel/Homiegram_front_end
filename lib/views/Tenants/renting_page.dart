import 'package:flutter/material.dart';

class RentingPage extends StatefulWidget {
  const RentingPage({super.key});

  @override
  State<RentingPage> createState() => _RentingPageState();
}

class _RentingPageState extends State<RentingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renting Page'),
        leading: Container(),
      ),
      body: const Center(
        child: Text('renting page'),
      ),
    );
  }
}
