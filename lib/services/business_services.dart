import 'dart:convert';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

Future<List<BusinessModel>> fetchBusinesses() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/business/getBusiness/'),
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

Future<List<Category>> fetchCategorys() async {
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/business/getCategorys/'),
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
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/business/getProducts/'),
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