// import 'package:flutter/widgets.dart';

class BusinessModel {
  final int businessId;
  final String businessName;
  final String contactNumber;
  final String businessEmail;
  final int businessAddress;
  final int businessOwnerId;
  final String businessImage;

  BusinessModel({
    required this.businessId,
    required this.businessName,
    required this.contactNumber,
    required this.businessEmail,
    required this.businessAddress,
    required this.businessOwnerId,
    required this.businessImage,
  });

  factory BusinessModel.fromJSon(Map<String, dynamic> json) {
    return BusinessModel(
      businessId: json['id'] ?? '',
      businessName: json['name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      businessEmail: json['email'] ?? '',
      businessAddress: json['location'] ?? 0,
      businessOwnerId: json['owner'],
      businessImage: json['image'] ?? '',
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'id': businessId,
      'name': businessName,
      'contact_number': contactNumber,
      'email': businessEmail,
      'location': businessAddress,
      'owner': businessOwnerId,
      'image': businessImage,
    };
  }
}

class Category {}
