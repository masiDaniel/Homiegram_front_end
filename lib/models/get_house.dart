// import 'package:flutter/widgets.dart';

class GetHouse {
  final int houseId;
  final String name;
  final String rentAmount;
  final int rating;
  final String description;
  final String location;
  final List<String>? images;
  final String bankName;
  final String accountNumber;
  final List<int> amenities;
  final int landlordId;
  final int? caretakerId;
  final String? contractUrl;

  GetHouse(
      {required this.houseId,
      required this.name,
      required this.rentAmount,
      required this.rating,
      required this.description,
      required this.location,
      this.images,
      required this.bankName,
      required this.accountNumber,
      required this.amenities,
      required this.landlordId,
      this.caretakerId,
      this.contractUrl});

  factory GetHouse.fromJSon(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['image'] != null) images.add(json['image']);
    if (json['image_1'] != null) images.add(json['image_1']);
    if (json['image_2'] != null) images.add(json['image_2']);
    if (json['image_3'] != null) images.add(json['image_3']);

    return GetHouse(
        houseId: json['id'] ?? '',
        name: json['name'] ?? '',
        rentAmount: json['rent_amount'] ?? '',
        rating: json['rating'] ?? '',
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        images: images,
        bankName: json['payment_bank_name'] ?? '',
        accountNumber: json['payment_account_number'] ?? '',
        amenities: List<int>.from(json['amenities'] ?? []),
        landlordId: json['landlord_id'],
        caretakerId: json['caretaker'],
        contractUrl: json['contract_file']);
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'rentAmount': rentAmount,
      'rating': rating,
      'description': description,
      'location': location,
      'amenities': amenities,
      'landlordId': landlordId,
    };
  }
}
