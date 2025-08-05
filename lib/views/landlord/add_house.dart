import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homi_2/components/my_snackbar.dart';
import 'package:homi_2/models/amenities.dart';
import 'package:homi_2/models/business.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/business_services.dart';
import 'package:homi_2/services/get_amenities.dart';
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
  late Future<List<Amenities>> futureAmenities;
  List<Locations> locations = [];
  List<Amenities> amenities = [];
  List<Amenities> selectedAmenities = [];
  List<Category> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadLocations();
    _loadAmenities();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await fetchCategorys();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _loadUserId() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userIdShared = id ?? 0;
    });
  }

  Future<void> _pickImages() async {
    if (_imageUrls.length >= 4) {
      showCustomSnackBar(context, 'You can only select up to 4 images.');
      return;
    }

    final List<XFile> images = await _picker.pickMultiImage();

    final int remainingSlots = 4 - _imageUrls.length;

    setState(() {
      _imageUrls.addAll(
        images.take(remainingSlots).map((file) => file.path),
      );
    });

    if (!mounted) return;

    if (images.length > remainingSlots) {
      showCustomSnackBar(
          context, 'Some images were not added due to the 4-image limit.');
    }
  }

  void _loadLocations() {
    futureLocations = fetchLocations();

    futureLocations.then((locs) {
      setState(() {
        locations = locs;
      });
    });
  }

  void _loadAmenities() {
    futureAmenities = fetchAmenities();

    futureAmenities.then((ames) {
      setState(() {
        amenities = ames;
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
                    labelText: 'Rent Amount ie (1B - ks 4000, 2B - ks 5000)',
                    border: OutlineInputBorder(),
                  ),
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
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Select Images'),
                ),
                const SizedBox(height: 16),
                _imageUrls.isNotEmpty
                    ? Wrap(
                        spacing: 8.0,
                        children: _imageUrls.take(4).map((url) {
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
                                      _imageUrls.remove(url);
                                    });
                                  },
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF105A01),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

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
                              locationDetail: _location,
                            );

                            setState(() {
                              isLoading = true;
                            });

                            bool success = await postHouseService
                                .postHouseWithImages(newHouse);

                            if (!context.mounted) return;

                            setState(() {
                              isLoading = false;
                            });

                            if (success) {
                              showCustomSnackBar(
                                  context, 'House added successfully!');
                              Navigator.pop(context);
                            } else {
                              showCustomSnackBar(
                                  context, 'Failed to add house.',
                                  type: SnackBarType.error);
                            }
                          }
                        },
                  child: isLoading
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Color(0xFF105A01),
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Adding...',
                              style: TextStyle(color: Color(0xFF105A01)),
                            ),
                          ],
                        )
                      : const Text(
                          'Add House',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
