import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:lottie/lottie.dart';

class ProductDetailPage extends StatelessWidget {
  final Products product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String productImage = product.productImage.isNotEmpty
        ? '$devUrl${product.productImage}'
        : 'assets/images/ad2.jpeg'; // Default image asset
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with error handling
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                productImage,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/ad2.jpeg', // Default image
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),

            // Product Name
            Text(
              product.productName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8.0),

            // Product Description
            Text(
              product.productDescription,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 16.0),

            // Price
            Text(
              'Price: Ksh ${product.productPrice}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 16.0),

            // Stock Availability
            Text(
              'Stock: ${product.stockAvailable}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(), // Pushes buttons to the bottom

            // Buttons: Buy Now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065F09),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Purchase Options'),
                          content: const Text(
                            'Would you like to buy directly or add this item to your cart?',
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF065F09),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(
                                            'assets/animations/moneySuccess.json',
                                            width: 100,
                                            height: 100,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Product purchased successfully!",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF065F09),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(
                                            'assets/animations/moneySuccess.json',
                                            width: 150,
                                            height: 100,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Product added to cart successfully!",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Add to cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Buy',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
