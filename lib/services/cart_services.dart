import 'dart:convert';
import 'package:homi_2/models/cart.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

class CartService {
  /// **Retrieve the cart**
  Future<Cart?> getCart(int? userId) async {
    String? token = await UserPreferences.getAuthToken();
    print("this is the token $token");

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    try {
      final response = await http.get(Uri.parse("$devUrl/business/getCarts/"),
          headers: headers);

      if (response.statusCode == 200) {
        print('Fetched successfully');

        // Parse the response as a Map instead of a List
        Map<String, dynamic> data = jsonDecode(response.body);
        print('This is the cart data: $data');

        return Cart.fromJson(data); // Directly convert to Cart
      }
      return null;
    } catch (e) {
      print("Error fetching cart: $e");
      return null;
    }
  }

  Future<Cart?> createCart(int? userId) async {
    String? token = await UserPreferences.getAuthToken();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
    var data = {"user": userId};
    try {
      final response = await http.post(Uri.parse("$devUrl/business/getCarts/"),
          headers: headers, body: jsonEncode(data));

      if (response.statusCode == 201) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          print('this is the cart data ${Cart.fromJson(data.first)}');
          return Cart.fromJson(data.first);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching cart: $e");
      return null;
    }
  }

  /// **Add products to the cart**
  Future<bool> addToCart(int cartId, List<int> productIds) async {
    try {
      final response = await http.patch(
        Uri.parse("$devUrl$cartId/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "products": productIds, // Send new product list
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error adding to cart: $e");
      return false;
    }
  }
}
