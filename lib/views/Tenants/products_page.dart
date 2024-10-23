import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/services/business_services.dart';
import 'package:homi_2/views/Tenants/pproduct_detail_page.dart';

class ProductsPage extends StatefulWidget {
  final int businessId;

  const ProductsPage({super.key, required this.businessId});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Products>> futureProducts;
  String baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    // Fetch the products when the page loads
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for Business ${widget.businessId}'),
      ),
      body: FutureBuilder<List<Products>>(
        future: futureProducts,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                String productImage = product.productImage.isNotEmpty
                    ? '$baseUrl${product.productImage}'
                    : 'assets/images/ad2.jpeg'; // Default image asset
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // Adding padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double
                              .infinity, // Make image stretch to card width
                          height: 200, // Adjust height as needed
                          child: Image.network(
                            productImage,
                            fit: BoxFit
                                .cover, // Ensure the image covers the available space
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/ad2.jpeg', // Default image
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              );
                            },
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
                            child: const Text('View Details'),
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
    );
  }
}
