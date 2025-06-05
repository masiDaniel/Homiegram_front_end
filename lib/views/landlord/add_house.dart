import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/get_locations.dart';
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
  int _location = 0;

  String _description = '';
  final String _bankName = '';
  final String __accountNumber = '';
  final List<String> _imageUrls = [];
  int? userIdShared;

  final PostHouseService postHouseService = PostHouseService();
  final ImagePicker _picker = ImagePicker();
  late Future<List<Locations>> futureLocations;
  List<Locations> locations = [];
  List<Amenities> amenities = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadLocations();
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

  void _loadLocations() {
    futureLocations = fetchLocations();

    // Fetch locations separately
    futureLocations.then((locs) {
      setState(() {
        locations = locs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add House'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
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
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(),
                  ),
                  items: locations.map((location) {
                    final label =
                        "${location.county}, ${location.town}, ${location.area}";
                    return DropdownMenuItem<int>(
                      value: location.locationId,
                      child: Text(label),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Select Amenities',
                    border: OutlineInputBorder(),
                  ),
                  items: locations.map((location) {
                    final label =
                        "${location.county}, ${location.town}, ${location.area}";
                    return DropdownMenuItem<int>(
                      value: location.locationId,
                      child: Text(label),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select amenities ';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
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

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Create a new house instance
                      final newHouse = GetHouse(
                          name: _houseName,
                          rentAmount: _rentAmount,
                          rating: 2,
                          description: _description,
                          images: _imageUrls,
                          amenities: [1],
                          landlordId: userIdShared as int,
                          houseId: 0,
                          bankName: _bankName,
                          accountNumber: __accountNumber,
                          location_detail: _location);

                      print("this is the new house ${newHouse}");

                      // Call the addHouse method and await the response
                      bool success =
                          await postHouseService.postHouseWithImages(newHouse);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 2),
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'House added successfully!',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to add house.')),
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
      ),
    );
  }
}
