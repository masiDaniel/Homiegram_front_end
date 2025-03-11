import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/post_house_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:image_picker/image_picker.dart';

class AddHousePage extends StatefulWidget {
  const AddHousePage({super.key});

  @override
  AddHousePageState createState() => AddHousePageState();
}

class AddHousePageState extends State<AddHousePage> {
  final _formKey = GlobalKey<FormState>();
  String _houseName = '';
  String _rentAmount = '';
  String _location = '';
  String _description = '';
  String _bankName = '';
  String __accountNumber = '';
  final List<String> _imageUrls = [];
  int? userIdShared;

  final PostHouseService postHouseService = PostHouseService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userIdShared = id ?? 0; // Default to 'tenant' if null
    });
  }

  Future<void> _pickImages() async {
    if (_imageUrls.length >= 4) {
      // Show a message or handle the limit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only select up to 4 images.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Prevent further image picking
    }

    final List<XFile> images = await _picker.pickMultiImage();
    // Calculate how many more images can be added
    final int remainingSlots = 4 - _imageUrls.length;

    setState(() {
      // Add only up to the remaining number of slots
      _imageUrls.addAll(
        images.take(remainingSlots).map((file) => file.path),
      );
    });

    // Check if the widget is still mounted before using the context
    if (!mounted) return;

    if (images.length > remainingSlots) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some images were not added due to the 4-image limit.'),
          duration: Duration(seconds: 2),
        ),
      );
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
              // Display selected images with restriction and deselect option
              _imageUrls.isNotEmpty
                  ? Wrap(
                      spacing: 8.0,
                      children: _imageUrls.take(4).map((url) {
                        // Limit to 4 images
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(
                              File(url),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _imageUrls.remove(
                                        url); // Remove the image from the list
                                  });
                                },
                                // ignore: prefer_const_constructors
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    )
                  : const Center(child: Text('No images selected.')),
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
                      rentAmount: _rentAmount,
                      rating: 2, // Assuming a default rating
                      description: _description, // Add description if available
                      location: _location,
                      images: _imageUrls, // Assuming a list of images
                      amenities: [1], // Include if you have amenities
                      landlordId: userIdShared as int,
                      houseId: 0,
                      bankName: _bankName,
                      accountNumber:
                          __accountNumber, // Set the correct landlord ID
                    );

                    // Call the addHouse method and await the response
                    bool success =
                        await postHouseService.postHouseWithImages(newHouse);

                    if (success) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('House added successfully!')),
                        );
                        Navigator.pop(
                            context); // Navigate back or clear the form
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add house.')),
                        );
                      }
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
