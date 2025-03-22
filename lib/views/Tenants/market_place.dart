import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/business_services.dart';
import 'package:homi_2/services/get_locations.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/add_product_screen.dart';
import 'package:homi_2/views/Tenants/business_bookmarks.dart';
import 'package:homi_2/views/Tenants/cart_page.dart';
import 'package:homi_2/views/Tenants/products_page.dart';
import 'package:lottie/lottie.dart';

class MarketPlace extends StatefulWidget {
  const MarketPlace({super.key});

  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  late Future<List<BusinessModel>> futureBusinesses;
  late Future<List<Locations>> futureLocations;
  List<BusinessModel> allBusinesses = [];
  List<Products> allProducts = [];
  List<BusinessModel> displayedBusinesses = [];
  List<Products> displayedProducts = [];
  List<Locations> locations = [];
  bool showBusinesses = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessesAndLocations();
    _loadProducts();
  }

  void _loadBusinessesAndLocations() {
    futureBusinesses = fetchBusinesses();
    futureLocations = fetchLocations();

    // Fetch businesses
    futureBusinesses.then((businesses) {
      setState(() {
        allBusinesses = businesses;
        displayedBusinesses = businesses;
      });
    });

    // Fetch locations separately
    futureLocations.then((locs) {
      setState(() {
        locations = locs;
      });
    });
  }

  Future<void> _loadProducts() async {
    final products = await fetchProductsSeller();
    setState(() {
      allProducts = products;
      displayedProducts = products;
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductPage(
                              businessId: 0,
                            )),
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
    int? selectedLocationId;

    void showLocationDialog(BuildContext context) {
      TextEditingController searchController = TextEditingController();
      List<Locations> filteredLocations = List.from(locations);

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Select Business Location"),
                content: SizedBox(
                  width: double.maxFinite, // Ensures proper width
                  height: 300, // Adjust height as needed
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: "Search Location",
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          setState(() {
                            filteredLocations = locations
                                .where((loc) =>
                                    loc.county!
                                        .toLowerCase()
                                        .contains(query.toLowerCase()) ||
                                    loc.town!
                                        .toLowerCase()
                                        .contains(query.toLowerCase()) ||
                                    loc.area!
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        // Ensures ListView gets proper constraints
                        child: ListView.builder(
                          itemCount: filteredLocations.length,
                          itemBuilder: (context, index) {
                            final loc = filteredLocations[index];
                            return ListTile(
                              title: Text(
                                  "${loc.county}, ${loc.town}, ${loc.area}"),
                              onTap: () {
                                setState(() {
                                  businessAddressController.text =
                                      "${loc.county}, ${loc.town}, ${loc.area}"; // Display name
                                  selectedLocationId =
                                      loc.locationId; // Store ID
                                });
                                Navigator.pop(context); // Close dialog
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

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
                    decoration: const InputDecoration(
                        labelText: 'Business Contact Number'),
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
                    decoration: const InputDecoration(
                        labelText: 'Business Email Address'),
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
                    readOnly: true, // Prevent manual typing
                    decoration: InputDecoration(
                      labelText: "Business Location",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => showLocationDialog(context),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a location';
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
                    'location': selectedLocationId,
                    'owner': id,
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

  void _filterResults(String query) {
    setState(() {
      displayedBusinesses = allBusinesses
          .where((business) =>
              business.businessName.toLowerCase().contains(query.toLowerCase()))
          .toList();

      displayedProducts = allProducts
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
          onChanged: _filterResults,
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
          // IconButton(
          //   icon: const Icon(Icons.bookmark_added),
          //   onPressed: () {
          //     // Navigate to the cart screen or handle cart actions
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               const BusinessBookmarks()), // Replace with your cart screen
          //     );
          //   },
          // ),
          IconButton(
            onPressed: () => _showPopup(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: _refreshBusinesses,
        child: Column(children: [
          // **Toggle Buttons**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => showBusinesses = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: showBusinesses
                      ? const Color(0xFF126E06)
                      : const Color(0xFFADE0A8),
                ),
                child: const Text(
                  "Businesses",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => showBusinesses = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showBusinesses
                      ? const Color(0xFF126E06)
                      : const Color(0xFFADE0A8),
                ),
                child: const Text(
                  "Products",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          // **Search Results Display**
          Expanded(
            child: showBusinesses ? _buildBusinessList() : _buildProductList(),
          ),
        ]),
      )),
    );
  }

  // **Build Business List**
  Widget _buildBusinessList() {
    return RefreshIndicator(
      onRefresh: _refreshBusinesses,
      child: FutureBuilder<List<Locations>>(
        future: futureLocations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Colors.green, strokeWidth: 6.0),
                  SizedBox(height: 10),
                  Text("Loading, please wait...",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Lottie.asset(
                'assets/animations/notFound.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            );
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
                      String businessImage = business.businessImage.isNotEmpty
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
                                  businessPhoneNumber: business.contactNumber,
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
                                    errorBuilder: (context, error, stackTrace) {
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
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        'Contact: ${business.contactNumber}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        'Category: ${business.businessTypeId}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white70),
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
                : const Center(child: Text('No businesses match your search.'));
          } else {
            return const Center(child: Text('No locations available'));
          }
        },
      ),
    );
  }

  // **Build Product List**
  Widget _buildProductList() {
    return displayedProducts.isNotEmpty
        ? ListView.builder(
            itemCount: displayedProducts.length,
            itemBuilder: (context, index) {
              Products product = displayedProducts[index];
              String productImage = product.productImage.isNotEmpty
                  ? '$devUrl${product.productImage}'
                  : 'assets/images/default_product.jpeg';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          spreadRadius: 1.0),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          productImage,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/default_product.jpeg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Price: ${product.productPrice}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            Text(
                              'Seller: ${product.productName}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black54),
                            ),
                            const SizedBox(height: 4.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF065F09)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(
                                              'assets/animations/callingServers.json',
                                              width: 100,
                                              height: 100),
                                          const SizedBox(height: 10),
                                          const Text("calling initiated!",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'call seller',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: Text("No standalone products found."));
  }
}
