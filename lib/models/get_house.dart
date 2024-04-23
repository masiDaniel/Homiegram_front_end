// import 'package:flutter/widgets.dart';

class GetHouse {
  final String name;
  final String rent_amount;
  final int rating;
  final String description;
  final String location;
  final List<String> images;

  GetHouse({
    required this.name,
    required this.rent_amount,
    required this.rating,
    required this.description,
    required this.location,
    required this.images,
  });

  factory GetHouse.fromJSon(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['image'] != null) images.add(json['image']);
    if (json['image_1'] != null) images.add(json['image_1']);
    if (json['image_2'] != null) images.add(json['image_2']);
    if (json['image_3'] != null) images.add(json['image_3']);

    return GetHouse(
      name: json['name'] ?? '',
      rent_amount: json['rent_amount'] ?? '',
      rating: json['rating'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      images: images,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'rent_amount': rent_amount,
      'rating': rating,
      'description': description,
      'location': location,
      'images': images,
    };
  }
}
