import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/get_users.dart';
import 'package:homi_2/models/locations.dart';
import 'package:homi_2/services/fetch_ads_service.dart';
import 'package:homi_2/services/get_locations.dart';
import 'package:homi_2/services/get_rooms_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/landlord/add_room.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

class HouseDetailsPage extends StatefulWidget {
  final GetHouse house;

  const HouseDetailsPage({Key? key, required this.house}) : super(key: key);

  @override
  State<HouseDetailsPage> createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetailsPage> {
  List<GerUsers> users = [];
  GerUsers? selectedUser;
  bool isLoading = false;
  File? selectedFile; // Holds the selected file.
  String? localFilePath;
  File? _selectedImage;
  List<Locations> locations = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    checkCaretakerStatus();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      List<Locations> fetchedLocations = await fetchLocations();
      setState(() {
        locations = fetchedLocations;
      });
    } catch (e) {
      log('error fetching locations!');
    }
  }

  String getLocationName(int locationId) {
    final location = locations.firstWhere(
      (loc) => loc.locationId == locationId,
      orElse: () => Locations(
        locationId: 0,
        area: "unknown",
      ), // Default value if not found
    );
    return '${location.area}, ${location.town}, ${location.county}';
  }

  String getUserName(int? cartakerId) {
    final caretaker = users.firstWhere(
      (loc) => loc.userId == cartakerId,
      orElse: () =>
          GerUsers(firstName: "select a user"), // Default value if not found
    );
    return '${caretaker.firstName}, ${caretaker.email}';
  }

  ///
  ///how will i transfer this to its own individual file?
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    String? token = await UserPreferences.getAuthToken();

    try {
      // Define your headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };

      // Call the endpoint
      final response = await http.get(
        Uri.parse('$devUrl/accounts/getUsers/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse the response
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.map((user) => GerUsers.fromJSon(user)).toList();
        });
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      // Check if the widget is still mounted before using the context
      if (!mounted) return;
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _assignCaretaker() async {
    if (selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a user')),
      );
      return;
    }
    String? token = await UserPreferences.getAuthToken();

    try {
      // Define your headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };

      // Call the endpoint
      final response = await http.post(
        Uri.parse('$devUrl/houses/assign-caretaker/'),
        headers: headers,
        body: json.encode({
          'house_id': widget.house.houseId,
          'user_id': selectedUser!.userId,
        }),
      );

      if (response.statusCode == 200) {
        // Check if the widget is still mounted before using the context
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Caretaker assigned successfully!')),
        );
      } else {
        throw Exception('Failed to assign caretaker');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning caretaker: $e')),
      );
    }
  }

  Future<void> _removeCaretaker() async {
    String? token = await UserPreferences.getAuthToken();
    try {
      // Define headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };

      // Make DELETE request
      final response = await http.delete(
        Uri.parse('$devUrl/houses/remove-caretaker/'),
        headers: headers,
        body: json.encode({
          'house_id': widget.house.houseId,
          'caretaker_id': widget.house.caretakerId,
        }),
      );

      // Check if the widget is still mounted before using the context
      if (!mounted) return;
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Caretaker removed successfully!')),
        );
      } else {
        final error = json.decode(response.body)['error'] ?? 'Unknown error';
        throw Exception(error);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing caretaker: $e')),
      );
    }
  }

  void showAdvertCreationDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();

    Future<void> selectDate(
        BuildContext context, TextEditingController controller) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        controller.text = pickedDate.toIso8601String().split('T')[0];
        // Format: YYYY-MM-DD
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Submit an Ad'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(titleController, 'Ad Title',
                          'Please enter the ad title'),
                      _buildTextField(descriptionController, 'Description',
                          'Please enter a description'),
                      buildImagePicker(
                        imageFile: _selectedImage,
                        onImagePicked: (file) => setState(() =>
                            _selectedImage = file), // << correct setState here
                        label: 'Image',
                        validationMessage: 'Please pick an image',
                        context: context,
                      ),
                      _buildDatePickerField(context, startDateController,
                          'Start Date', selectDate),
                      _buildDatePickerField(
                          context, endDateController, 'End Date', selectDate),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final Ad businessData = Ad(
                          title: titleController.text,
                          description: descriptionController.text,
                          startDate: dateFormat
                              .format(DateTime.parse(startDateController.text)),
                          endDate: dateFormat
                              .format(DateTime.parse(endDateController.text)),
                        );

                        postAds(businessData, _selectedImage).then((message) {
                          if (context.mounted) {
                            _showSuccessDialog(context);
                            () => Navigator.of(context).pop();
                          }
                        }).catchError((error) {
                          if (context.mounted) {
                            _showErrorDialog(context, error.toString());
                          }
                        });
                      } catch (e, stackTrace) {
                        log("ERROR during ad submission: $e");
                        log("STACKTRACE:\n$stackTrace");

                        if (context.mounted) {
                          _showErrorDialog(context, e.toString());
                        }
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? validationMessage : null,
    );
  }

  Widget buildImagePicker({
    required File? imageFile,
    required Function(File?) onImagePicked,
    required String label,
    required String validationMessage,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picker = ImagePicker();
            final picked = await picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              onImagePicked(File(picked.path));
            }
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: imageFile != null
                ? Image.file(imageFile, fit: BoxFit.cover)
                : const Center(child: Text('Tap to pick image')),
          ),
        ),
        const SizedBox(height: 8),
        if (imageFile == null)
          Text(validationMessage, style: const TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context,
      TextEditingController controller, String label, Function pickerFunction) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => pickerFunction(context, controller),
        ),
      ),
      readOnly: true,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a date' : null,
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Ad submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close success dialog
                Navigator.of(context).pop(); // Close main dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.house.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'House Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            _buildHouseDetailsCard(),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Assign Caretaker',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.house.caretakerId == null)
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<GerUsers>(
                      value: selectedUser,
                      items: users
                          .map((user) => DropdownMenuItem(
                                value: user,
                                child:
                                    Text('${user.firstName} (${user.email})'),
                              ))
                          .toList(),
                      onChanged: (user) {
                        setState(() {
                          selectedUser = user;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select a User',
                      ),
                    ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  isCaretakerAssigned ? _removeCaretaker : _assignCaretaker,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: isCaretakerAssigned
                    ? const Color.fromARGB(255, 124, 15, 5)
                    : const Color(0xFF013803),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isCaretakerAssigned ? 'Remove Caretaker' : 'Assign Caretaker',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 30,
            ),
            const Text('Rooms'),
            FutureBuilder(
              future: fetchRoomsByHouse(widget.house.houseId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final rooms = snapshot.data!;

                  if (rooms.isEmpty) {
                    return const Center(
                        child: Text('No rooms found for this house.'));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      final isAvailable = room.tenantId == 0;
                      final backgroundColor = isAvailable
                          ? Colors.white
                          : room.rentStatus
                              ? const Color(0xFF158518) // Paid
                              : const Color(0xFF8C1A1A); // Unpaid

                      final textColor =
                          isAvailable ? Colors.black : Colors.white;
                      final borderColor = isAvailable
                          ? const Color(0xFF158518)
                          : Colors.transparent;

                      return GestureDetector(
                        onTap: () {
                          // Navigate to room details
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.roomName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.king_bed,
                                      size: 16, color: textColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room.noOfBedrooms} bedrooms',
                                    style: TextStyle(color: textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      size: 16, color: textColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${room.rentAmount}',
                                    style: TextStyle(color: textColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 16, color: textColor),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      isAvailable
                                          ? 'Available'
                                          : getUserName(room.tenantId),
                                      style: TextStyle(
                                        fontStyle: isAvailable
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No rooms available'));
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color(0xFF013803),
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add_home),
            label: 'Add Room',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RoomInputPage(apartmentId: widget.house.houseId),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.tv),
            label: 'Advertise',
            onTap: () {
              showAdvertCreationDialog(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.auto_graph),
            label: 'Statistics',
            onTap: () {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: 'Edit house',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  bool isCaretakerAssigned = false;

// Update this variable based on the backend response or local state.
  void checkCaretakerStatus() {
    // Example: Check if caretaker is assigned.
    setState(() {
      isCaretakerAssigned = widget.house.caretakerId != null;
    });
  }

  Widget _buildHouseDetailsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF013803),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Slider using PageView

          SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              itemCount: widget.house.images!.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    "$devUrl${widget.house.images![index]}",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.house.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 5),
                    Text(getLocationName(widget.house.location_detail),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money,
                        color: Colors.green, size: 18),
                    const SizedBox(width: 5),
                    Text('ksh ${widget.house.rentAmount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue, size: 18),
                    const SizedBox(width: 5),
                    Text('Caretaker: ${getUserName(widget.house.caretakerId)}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
