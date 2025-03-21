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
            Image.network(
              productImage,
              errorBuilder: (context, error, stackTrace) {
                // Handle any errors in loading the image
                return Image.asset(
                  'assets/images/ad2.jpeg', // Default image
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              product.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(product.productDescription),
            const SizedBox(height: 16.0),
            Text('Price: \$${product.productPrice}'),
            const SizedBox(height: 16.0),
            Text('Stock: ${product.stockAvailable}'),

            // Spacer to push buttons to the bottom
            const Spacer(),

            // Buttons: Bookmark and Buy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///
                /// will return this after playstore verifies
                ///
                // ElevatedButton.icon(
                //   style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color.fromARGB(255, 6, 95, 9)),
                //   onPressed: () {
                //     // Handle bookmark functionality
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           title: const Text('Coming Soon!'),
                //           content: const Text(
                //               'This feature will be available in future updates.'),
                //           actions: [
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop(); // Close the dialog
                //               },
                //               child: const Text('OK'),
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   },
                //   icon: const Icon(
                //     Icons.bookmark,
                //     color: Colors.white,
                //   ),
                //   label: const Text(
                //     'Bookmark',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF065F09)),
                  onPressed: () {
                    // Handle buy functionality
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Purchase Options'),
                          content: const Text(
                              'Would you like to buy directly or add this item to your cart?'),
                          actions: [
                            // TextButton(
                            //   style: ElevatedButton.styleFrom(
                            //       backgroundColor: const Color(0xFF065F09)),
                            //   onPressed: () {
                            //     // Add to Cart action logic here
                            //     Navigator.of(context).pop(); // Close the dialog
                            //     // For example: cartController.addItem(item);
                            //   },
                            //   child: const Text(
                            //     'Add to Cart',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF065F09)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the first dialog
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
                                              height: 100),
                                          const SizedBox(height: 10),
                                          const Text(
                                              "Product purchased successfully!",
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
                                'Buy Now',
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
                  label:
                      const Text('Buy', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
