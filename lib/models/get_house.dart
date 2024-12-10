// import 'package:flutter/widgets.dart';

class GetHouse {
  final int HouseId;
  final String name;
  final String rent_amount;
  final int rating;
  final String description;
  final String location;
  final List<String>? images;
  final String bankName;
  final String accountNumber;
  final List<int> amenities;
  final int landlord_id;
  final int? caretaker_id;

  GetHouse(
      {required this.HouseId,
      required this.name,
      required this.rent_amount,
      required this.rating,
      required this.description,
      required this.location,
      this.images,
      required this.bankName,
      required this.accountNumber,
      required this.amenities,
      required this.landlord_id,
      this.caretaker_id});

  factory GetHouse.fromJSon(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['image'] != null) images.add(json['image']);
    if (json['image_1'] != null) images.add(json['image_1']);
    if (json['image_2'] != null) images.add(json['image_2']);
    if (json['image_3'] != null) images.add(json['image_3']);

    return GetHouse(
        HouseId: json['id'] ?? '',
        name: json['name'] ?? '',
        rent_amount: json['rent_amount'] ?? '',
        rating: json['rating'] ?? '',
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        images: images,
        bankName: json['payment_bank_name'] ?? '',
        accountNumber: json['payment_account_number'] ?? '',
        amenities: List<int>.from(json['amenities'] ?? []),
        landlord_id: json['landlord_id'],
        caretaker_id: json['caretaker']);
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'rent_amount': rent_amount,
      'rating': rating,
      'description': description,
      'location': location,
      'amenities': amenities,
      'landlord_id': landlord_id,
    };
  }
}
