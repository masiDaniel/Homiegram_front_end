import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/business_services.dart';
import 'package:homi_2/services/get_locations.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/business_bookmarks.dart';
import 'package:homi_2/views/Tenants/cart_page.dart';
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
    _loadBusinessesAndLocations();
  }

  void _loadBusinessesAndLocations() {
    futureBusinesses = fetchBusinesses();
    futureLocations = fetchLocations();
    futureBusinesses.then((businesses) {
      setState(() {
        allBusinesses = businesses;
        displayedBusinesses = businesses; // Initialize with all businesses
      });
    });
  }

  Future<void> _refreshBusinesses() async {
    final businesses = await fetchBusinesses();
    setState(() {
      allBusinesses = businesses;
      displayedBusinesses = businesses;
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 6, 95, 9)),
                onPressed: () => showBusinessCreationDialog(context),
                child: const Text(
                  'Create a Business',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 6, 95, 9)),
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
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 6, 95, 9)),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Sell a Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showBusinessCreationDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController businessNameController =
        TextEditingController();
    final TextEditingController contactNumberController =
        TextEditingController();
    final TextEditingController businessEmailController =
        TextEditingController();
    final TextEditingController businessAddressController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Business'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: businessNameController,
                    decoration:
                        const InputDecoration(labelText: 'Business Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the business name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: contactNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the contact number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: businessEmailController,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: businessAddressController,
                    decoration: const InputDecoration(labelText: 'Address ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address ID';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 2, 51, 4)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 95, 9)),
              onPressed: () async {
                int? id = await UserPreferences.getUserId();
                if (formKey.currentState!.validate()) {
                  final businessData = {
                    'name': businessNameController.text,
                    'contact_number': contactNumberController.text,
                    'email': businessEmailController.text,
                    'location':
                        int.tryParse(businessAddressController.text) ?? 0,
                    'owner': id, // Replace with actual owner ID
                  };
                  postBusiness(businessData, context).then((success) {
                    if (success) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content:
                                const Text('Business created successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the success dialog
                                  _refreshBusinesses(); // Refresh data
                                  Navigator.of(context)
                                      .pop(); // Close the parent dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
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
        automaticallyImplyLeading: false,
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
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the cart screen or handle cart actions
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const CartScreen()), // Replace with your cart screen
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_added),
            onPressed: () {
              // Navigate to the cart screen or handle cart actions
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const BusinessBookmarks()), // Replace with your cart screen
              );
            },
          ),
          IconButton(
            onPressed: () => _showPopup(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshBusinesses,
          child: FutureBuilder<List<Locations>>(
            future: futureLocations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.green, // Custom color
                        strokeWidth: 6.0, // Thicker stroke
                      ),
                      SizedBox(height: 10),
                      Text("Loading, please wait...",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  )),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading locations'));
              } else if (snapshot.hasData && snapshot.data != null) {
                List<Locations> locations = snapshot.data!;
                Map<int, Locations> locationMap = {
                  for (var location in locations) location.locationId: location
                };

                return displayedBusinesses.isNotEmpty
                    ? ListView.builder(
                        itemCount: displayedBusinesses.length,
                        itemBuilder: (context, index) {
                          BusinessModel business = displayedBusinesses[index];
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
                                      businessOwnerId: business.businessOwnerId,
                                      businessPhoneNumber:
                                          business.contactNumber,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        },
                      )
                    : const Center(
                        child: Text('No businesses match your search.'));
              } else {
                return const Center(child: Text('No locations available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
