import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

Future<List<BusinessModel>> fetchBusinesses() async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.get(Uri.parse('$devUrl/business/getBusiness/'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> businessData = json.decode(response.body);

      final List<BusinessModel> businesses =
          businessData.map((json) => BusinessModel.fromJSon(json)).toList();

      return businesses;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<bool> postBusiness(
  Map<String, Object?> businessData,
  BuildContext context,
) async {
  String? token = await UserPreferences.getAuthToken();
  try {
    print('this is the business data ${businessData}');
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('$devUrl/business/getBusiness/'),
      headers: headersWithToken,
      body: json.encode(businessData),
    );

    if (response.statusCode == 201) {
      log('Business created successfully.');
      if (context.mounted) {
        // Check if the widget is still in the widget tree
        Navigator.of(context).pop();
      }
      return true;
    } else {
      log('Failed to create business: ${response.body}');
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<List<Category>> fetchCategorys() async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.get(Uri.parse('$devUrl/business/getCategorys/'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> categoryData = json.decode(response.body);

      final List<Category> categories =
          categoryData.map((json) => Category.fromJSon(json)).toList();

      return categories;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<Products>> fetchProducts() async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.get(Uri.parse('$devUrl/business/getProducts/'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);

      final List<Products> products =
          productsData.map((json) => Products.fromJSon(json)).toList();

      return products;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<Products>> fetchProductsSeller() async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.get(
        Uri.parse('$devUrl/business/getProducts/?business=null'),
        headers: headersWithToken);

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);

      final List<Products> products =
          productsData.map((json) => Products.fromJSon(json)).toList();

      return products;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<bool> postProducts(
  Map<String, Object?> productData,
) async {
  String? token = await UserPreferences.getAuthToken();
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $token',
    };

    final response = await http.post(
      Uri.parse('$devUrl/business/postProducts/'),
      headers: headersWithToken,
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      log('Failed to post product: ${response.body}');
      return false;
    }
  } catch (e) {
    rethrow;
  }
}
