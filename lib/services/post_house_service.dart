import 'dart:convert';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

class PostHouseService {
  final String apiUrl =
      '${devUrl}houses/gethouses/'; // Replace with your API URL

  Future<bool> addHouse(GetHouse house) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $authToken',
      },
      body: jsonEncode(house.tojson()),
    );

    if (response.statusCode == 201) {
      // The house was added successfully
      return true;
    } else {
      // Handle error response
      print('Failed to add house: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  // Function to post a new house with images
  Future<bool> postHouseWithImages(GetHouse house) async {
    final dio = Dio();

    FormData formData = FormData();
    formData.fields.add(MapEntry('name', house.name));
    formData.fields.add(MapEntry('rent_amount', house.rent_amount));
    formData.fields.add(MapEntry('rating', house.rating.toString()));
    formData.fields.add(MapEntry('description', house.description));
    formData.fields.add(MapEntry('location', house.location));
    formData.fields.add(MapEntry('landlord_id', house.landlord_id.toString()));
    for (int amenity in house.amenities) {
      formData.fields.add(MapEntry('amenities', amenity.toString()));
    }

    // Add images if they exist
    if (house.images != null) {
      for (String image in house.images!) {
        // Assuming the image is a file path or a URL
        formData.files
            .add(MapEntry('images', await MultipartFile.fromFile(image)));
      }
    }
    print(formData);

    try {
      final response = await dio.post(
        '$devUrl/houses/gethouses/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $authToken',
          },
        ),
      );
      return true;
    } on DioException catch (e) {
      print('Failed to post house: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');
      print('Status message: ${e.response?.statusMessage}');
      print(authToken);
      return false;
    }

    // if (response.statusCode == 200) {
    //   // Successfully posted
    //   print('House posted successfully');
    //   return true;
    // } else {
    //   // Handle the error
    //   print('Failed to post house: ${response.data}');
    //   return false;
    // }
  }
}
