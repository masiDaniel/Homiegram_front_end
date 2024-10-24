import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';

class ProductDetailPage extends StatelessWidget {
  final Products product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';
    String productImage = product.productImage.isNotEmpty
        ? '$baseUrl${product.productImage}'
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
            Text('Stock: ${product.StockAvailable}'),

            // Spacer to push buttons to the bottom
            const Spacer(),

            // Buttons: Bookmark and Buy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle bookmark functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product bookmarked!')),
                    );
                  },
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Bookmark'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle buy functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Purchase initiated!')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
