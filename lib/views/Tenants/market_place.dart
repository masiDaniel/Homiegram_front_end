import 'package:flutter/material.dart';

class MarketPlace extends StatefulWidget {
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _RentingPageState();
}

class _RentingPageState extends State<MarketPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('market Page'),
          leading: Container(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center elements horizontally
                children: [
                  Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xFF126E06),
                      borderRadius: BorderRadius.circular(
                          12.0), // Optional: for rounded edges
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Image.asset(
                          'assets/images/ad3.jpeg',
                          height: 400, // Adjust the height as needed
                          width: double.infinity,
                          fit: BoxFit
                              .cover, // Ensures the image covers the width
                        ),
                        const Padding(
                          padding: EdgeInsets.all(
                              8.0), // Adds some padding around the text
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Business Name (drinking Water)',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.0), // Space between the texts
                              Text(
                                'Location:\n 123 Main Street, City, Country',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xFF126E06),
                      borderRadius: BorderRadius.circular(
                          12.0), // Optional: for rounded edges
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Image.asset(
                          'assets/images/ad1.jpeg',
                          height: 400, // Adjust the height as needed
                          width: double.infinity,
                          fit:
                              BoxFit.fill, // Ensures the image covers the width
                        ),
                        const Padding(
                          padding: EdgeInsets.all(
                              8.0), // Adds some padding around the text
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Business Name (Fries palace)',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.0), // Space between the texts
                              Text(
                                'Location:\n daystar, Mavoko, Nairobi',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xFF126E06),
                      borderRadius: BorderRadius.circular(
                          12.0), // Optional: for rounded edges
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Image.asset(
                          'assets/images/ad3.jpeg',
                          height: 400, // Adjust the height as needed
                          width: double.infinity,
                          fit:
                              BoxFit.fill, // Ensures the image covers the width
                        ),
                        const Padding(
                          padding: EdgeInsets.all(
                              8.0), // Adds some padding around the text
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Business Name (Groceries)',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.0), // Space between the texts
                              Text(
                                'Location:\n 123 Mama mboga, eldoret city, Eldoret',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
