import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/services/business_services.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/pproduct_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsPage extends StatefulWidget {
  final int businessId;
  final String businessName;
  final int businessOwnerId;
  final String businessPhoneNumber;

  const ProductsPage(
      {super.key,
      required this.businessId,
      required this.businessName,
      required this.businessOwnerId,
      required this.businessPhoneNumber});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with TickerProviderStateMixin {
  late Future<List<Products>> futureProducts;
  int? userId;

  @override
  void initState() {
    super.initState();
    // Fetch the products when the page loads
    futureProducts = fetchProducts();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userId = id ?? 0; // Default to 'tenant' if null
    });
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for ${widget.businessName}'),
        // actions: [],
      ),
      body: FutureBuilder<List<Products>>(
        future: futureProducts,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(
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
          }
          // Error state
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Data is available
          else if (snapshot.hasData) {
            // Filter products based on the businessId
            List<Products> filteredProducts = snapshot.data!
                .where((product) => product.businessId == widget.businessId)
                .toList();

            if (filteredProducts.isEmpty) {
              return const Center(child: Text('No products available.'));
            }

            // Display the list of filtered products
            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                // String productImage = product.productImage.isNotEmpty
                //     ? '$devUrl${product.productImage}'
                //     : 'assets/images/ad2.jpeg'; // Default image asset
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Adding padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: product.productImage.isNotEmpty
                              ? Image.network(
                                  '$devUrl${product.productImage}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/ad2.jpeg', // Default image in case of error
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/ad2.jpeg', // Default image when there is no product image
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        const SizedBox(height: 8.0), // Add some spacing
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(product.productDescription),
                        const SizedBox(height: 4.0),
                        Text(
                          'Price: \$${product.productPrice}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Button or action row
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 6, 95, 9)),
                            onPressed: () {
                              // Handle tap event, e.g., navigating to product details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: const Text(
                              'View Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No products available.'));
          }
        },
      ),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: const Color(0xFF065F09),
          foregroundColor: Colors.white,
          overlayColor: const Color.fromARGB(255, 11, 71, 1),
          overlayOpacity: 0.8,
          elevation: 8.0,
          spaceBetweenChildren: 15,
          children: userId == widget.businessOwnerId
              ? [
                  SpeedDialChild(
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    backgroundColor: const Color(0xFF03AA19),
                    label: 'Add product',
                    labelStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    labelBackgroundColor: Colors.white,
                    onTap: () {},
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.tv),
                    label: 'Advertise',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AddHousePage()),
                      // );
                    },
                  ),
                ]
              : [
                  SpeedDialChild(
                    child: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    backgroundColor: const Color(0xFF03AA19),
                    label: 'Business info',
                    labelStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    labelBackgroundColor: Colors.white,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AddHousePage()),
                      // );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.call),
                    label: 'Call business',
                    onTap: () {
                      makePhoneCall(widget.businessPhoneNumber);
                    },
                  ),
                ]),
    );
  }
}
