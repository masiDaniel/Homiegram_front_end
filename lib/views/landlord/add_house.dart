import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/post_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:image_picker/image_picker.dart';

class AddHousePage extends StatefulWidget {
  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  final _formKey = GlobalKey<FormState>();
  String _houseName = '';
  String _rentAmount = '';
  String _location = '';
  String _description = '';
  String _bankName = '';
  String __accountNumber = '';
  List<String> _imageUrls = [];

  final PostHouseService postHouseService = PostHouseService();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _imageUrls.addAll(images.map((file) => file.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add House'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'House Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a house name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _houseName = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Rent Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rent amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _rentAmount = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              const SizedBox(height: 16),
              // Button to pick images
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Select Images'),
              ),
              const SizedBox(height: 16),
              // Display selected images
              _imageUrls.isNotEmpty
                  ? Wrap(
                      spacing: 8.0,
                      children: _imageUrls.map((url) {
                        return Image.file(
                          File(url),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    )
                  : const Text('No images selected.'),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'descripion',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a descriptiom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bank name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bankName = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'account number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account number';
                  }
                  return null;
                },
                onSaved: (value) {
                  __accountNumber = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Create a new house instance
                    final newHouse = GetHouse(
                      name: _houseName,
                      rent_amount: _rentAmount,
                      rating: 2, // Assuming a default rating
                      description: _description, // Add description if available
                      location: _location,
                      images: _imageUrls, // Assuming a list of images
                      amenities: [1], // Include if you have amenities
                      landlord_id: userId as int,
                      HouseId: 0,
                      bankName: _bankName,
                      accountNumber:
                          __accountNumber, // Set the correct landlord ID
                    );
                    print(newHouse.name);
                    // Call the addHouse method and await the response
                    bool success =
                        await postHouseService.postHouseWithImages(newHouse);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('House added successfully!')),
                      );
                      Navigator.pop(context); // Navigate back or clear the form
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add house.')),
                      );
                    }
                  }
                },
                child: const Text('Add House'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}