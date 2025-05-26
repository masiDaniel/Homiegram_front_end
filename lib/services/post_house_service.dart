import 'dart:convert';
import 'dart:developer';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PostHouseService {
  final String apiUrl = '${devUrl}houses/gethouses/';

  Future<bool> addHouse(GetHouse house) async {
    String? token = await UserPreferences.getAuthToken();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(house.tojson()),
    );

    if (response.statusCode == 201) {
      // The house was added successfully
      return true;
    } else {
      // Handle error response
      log('Failed to add house: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  Future<bool> postHouseWithImages(GetHouse house) async {
    final dio = Dio();

    FormData formData = FormData();
    formData.fields.add(MapEntry('name', house.name));
    formData.fields.add(MapEntry('rent_amount', house.rentAmount));
    formData.fields.add(MapEntry('rating', house.rating.toString()));
    formData.fields.add(MapEntry('description', house.description));
    formData.fields
        .add(MapEntry('location_detail', house.location_detail.toString()));

    formData.fields.add(MapEntry('landlord_id', house.landlordId.toString()));

    // Adding amenities as form fields
    for (int amenity in house.amenities) {
      formData.fields.add(MapEntry('amenities', amenity.toString()));
    }

    // Add images as multipart files
    if (house.images != null) {
      for (int i = 0; i < house.images!.length; i++) {
        String imagePath = house.images![i];

        // Create a MultipartFile for each image
        var file = await MultipartFile.fromFile(imagePath,
            filename: imagePath.split('/').last);

        // Dynamically set the field name like 'image' for the first image, 'image_1', 'image_2' for others
        String fieldName = i == 0 ? 'image' : 'image_$i';

        formData.files.add(MapEntry(
          fieldName, // 'image' for the first one, 'image_1', 'image_2' for others
          file,
        ));
      }
    }
    String? token = await UserPreferences.getAuthToken();
    try {
      final response = await dio.post(
        '$devUrl/houses/gethouses/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return true;
    } on DioException catch (e) {
      log('Failed to post house: ${e.response?.data}');
      return false;
    }
  }
}
