import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/business_services.dart';
import 'package:homi_2/services/get_locations.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/products_page.dart';

class MarketPlace extends StatefulWidget {
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  late Future<List<BusinessModel>> futureBusinesses;
  late Future<List<Locations>> futureLocations;
  List<BusinessModel> allBusinesses = [];
  List<BusinessModel> displayedBusinesses = [];

  @override
  void initState() {
    super.initState();
    futureBusinesses = fetchBusinesses();
    futureLocations = fetchLocations();
    futureBusinesses.then((businesses) {
      setState(() {
        allBusinesses = businesses;
        displayedBusinesses = businesses; // Initialize with all businesses
      });
    });
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Business or Sell Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Coming Soon!'),
                        content: const Text(
                            'This feature will be available in future updates.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Create a Business'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Coming Soon!'),
                        content: const Text(
                            'This feature will be available in future updates.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Sell a Product'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search Business...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              displayedBusinesses = allBusinesses
                  .where((business) => business.businessName
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _showPopup(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Locations>>(
          future: futureLocations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading locations'));
            } else if (snapshot.hasData && snapshot.data != null) {
              List<Locations> locations = snapshot.data!;
              Map<int, Locations> locationMap = {
                for (var location in locations) location.locationId: location
              };

              return displayedBusinesses.isNotEmpty
                  ? SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: displayedBusinesses.map((business) {
                            String businessImage =
                                business.businessImage.isNotEmpty
                                    ? '$devUrl${business.businessImage}'
                                    : 'assets/images/ad2.jpeg';

                            Locations? businessLocation =
                                locationMap[business.businessAddress];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductsPage(
                                        businessId: business.businessId,
                                        businessName: business.businessName,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF126E06),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          businessImage,
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/ad2.jpeg',
                                              width: double.infinity,
                                              height: 300,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              business.businessName,
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              businessLocation != null
                                                  ? 'Location: ${businessLocation.area}, ${businessLocation.county}, ${businessLocation.town}'
                                                  : 'Location: Unknown',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              'Contact: ${business.contactNumber}',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              'Category: ${business.businessTypeId}',
                                              style: const TextStyle(
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
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('No businesses match your search.'));
            } else {
              return const Center(child: Text('No locations available'));
            }
          },
        ),
      ),
    );
  }
}
