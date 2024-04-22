// import 'package:flutter/widgets.dart';

class GetHouse {
  final String? name;
  final String? rent_amount;
  final int? rating;
  final String? description;
  final String? location;
  final String? image;
  final String? image_1;
  final String? image_2;
  final String? image_3;

  GetHouse(
      {this.name,
      this.rent_amount,
      this.rating,
      this.description,
      this.location,
      this.image,
      this.image_1,
      this.image_2,
      this.image_3});

  factory GetHouse.fromJSon(Map<String, dynamic> json) {
    return GetHouse(
      name: json['name'],
      rent_amount: json['rent_amount'],
      rating: json['rating'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      image_1: json['image_1'],
      image_2: json['image_2'],
      image_3: json['image_3'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'rent_amount': rent_amount,
      'rating': rating,
      'description': description,
      'location': location,
      'image': image,
      'image_1': image_1,
      'image_2': image_2,
      'image_3': image_3
    };
  }
}
