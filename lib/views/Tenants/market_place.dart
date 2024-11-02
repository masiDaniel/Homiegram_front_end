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
                // Add your logic to create a business here
                Navigator.of(context).pop();
                // For example, navigate to a business creation screen
              },
              child: const Text('Create a Business'),
            ),
            SizedBox(height: 10), // Add space between buttons
            ElevatedButton(
              onPressed: () {
                // Add your logic to sell a product here
                Navigator.of(context).pop();
                // For example, navigate to a product selling screen
              },
              child: const Text('Sell a Product'),
            ),
          ],
        ),
      );
    },
  );
}

class _MarketPlaceState extends State<MarketPlace> {
  late Future<List<BusinessModel>> futureBusinesses;
  late Future<List<Locations>> futureLocations;
  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureBusinesses = fetchBusinesses(); // Fetch businesses
    futureLocations = fetchLocations(); // Fetch locations
    futureCategories = fetchCategorys();
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
                  // Add your logic to create a business here
                  Navigator.of(context).pop();
                  // Navigate to the business creation screen
                },
                child: const Text('Create a Business'),
              ),
              const SizedBox(height: 10), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  // Add your logic to sell a product here
                  Navigator.of(context).pop();
                  // Navigate to the product selling screen
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
        title: const Text('Market Place'),
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () => _showPopup(context), icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<BusinessModel>>(
          future: futureBusinesses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading businesses'));
            } else if (snapshot.hasData && snapshot.data != null) {
              List<BusinessModel> businesses = snapshot.data!;

              return FutureBuilder<List<Locations>>(
                future: futureLocations, // Fetch locations
                builder: (context, locationSnapshot) {
                  if (locationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (locationSnapshot.hasError) {
                    return const Center(child: Text('Error loading locations'));
                  } else if (locationSnapshot.hasData &&
                      locationSnapshot.data != null) {
                    List<Locations> locations = locationSnapshot.data!;

                    // Create a map of locationId -> Locations for quick lookup
                    Map<int, Locations> locationMap = {
                      for (var location in locations)
                        location.locationId: location
                    };

                    return SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: businesses.map((business) {
                            // Check if the business image is empty or null
                            String businessImage = business
                                    .businessImage.isNotEmpty
                                ? '$azurebaseUrl${business.businessImage}'
                                : 'assets/images/ad2.jpeg'; // Default image asset

                            // Find the corresponding location for the business
                            Locations? businessLocation =
                                locationMap[business.businessAddress];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  // navigate to the business page.
                                  print("item clicked");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductsPage(
                                          businessId: business
                                              .businessId), // Pass the business ID
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
                                      // Display business image with a default fallback
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          businessImage,
                                          width: double.infinity,
                                          height:
                                              300, // Set a height if necessary
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // Handle any errors in loading the image
                                            return Image.asset(
                                              'assets/images/ad2.jpeg', // Default image
                                              width: double.infinity,
                                              height: 300,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
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
                                            // Display the matched location data
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
                                              'Contact: ${business.contactNumber},',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              'Category: ${business.businessTypeId},',
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
                    );
                  } else {
                    return const Center(child: Text('No locations available'));
                  }
                },
              );
            } else {
              return const Center(child: Text('No businesses available'));
            }
          },
        ),
      ),
    );
  }
}
