import 'package:flutter/material.dart';
import 'package:homi_2/models/cart.dart';
import 'package:homi_2/services/cart_services.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();
  late Future<Cart?>
      userCartFuture; // Use Future instead of manually handling state

  @override
  void initState() {
    super.initState();
    userCartFuture = _loadCart();
  }

  Future<Cart?> _loadCart() async {
    try {
      int? userId = await UserPreferences.getUserId();
      return await cartService.getCart(userId);
    } catch (e) {
      debugPrint("Error loading cart: $e");
      return null; // Return null if there's an error
    }
  }

  Future<void> _createCart() async {
    int? userId = await UserPreferences.getUserId();
    if (userId == null) return;

    try {
      Cart? newCart = await cartService
          .createCart(userId); // Assuming you have a createCart method
      if (newCart != null) {
        setState(() {
          userCartFuture = Future.value(newCart);
        });
      }
    } catch (e) {
      debugPrint("Error creating cart: $e");
    }
  }

  // Future<void> _addItemsToCart(List<int> productIds) async {
  //   final cart = await userCartFuture;
  //   if (cart == null) return;

  //   bool success = await cartService.addToCart(cart.id, productIds);
  //   if (success) {
  //     setState(() {
  //       userCartFuture = _loadCart(); // Refresh the cart
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: FutureBuilder<Cart?>(
        future: userCartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load cart"));
          }

          final userCart = snapshot.data;
          if (userCart == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No cart found. Create one to start shopping."),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createCart,
                    child: const Text("Create Cart"),
                  ),
                ],
              ),
            );
          }

          return userCart.products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/empty_cart.json', // Ensure this file is in assets
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Your cart is empty!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: userCart.products.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Product ID: ${userCart.products[index]}"),
                    );
                  },
                );
        },
      ),
    );
  }
}
