import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/get_users.dart';
import 'package:homi_2/services/fetch_ads_service.dart';
import 'package:homi_2/services/get_rooms_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/landlord/add_room.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    checkCaretakerStatus();
    _downloadAndSaveFile('$devUrl${widget.house.contractUrl}');
  }

  ///
  ///how will i transfer this to its own individual file?
  Future<void> _fetchUsers() async {
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

  // Function to pick a file
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'], // Allow only PDF and TXT files
      );

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File selected: ${selectedFile!.path}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  // Function to upload the file
  Future<void> _uploadFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file first')),
      );
      return;
    }

    String? token = await UserPreferences.getAuthToken();

    try {
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Token $token',
      };

      final uri =
          Uri.parse('$devUrl/houses/updateHouse/${widget.house.houseId}/');
      final request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
          'contract_file', // Backend expects this key for the file
          selectedFile!.path,
        ));

      final response = await request.send();

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contract uploaded successfully!')),
        );
      } else {
        throw Exception('Failed to upload contract');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> _downloadAndSaveFile(String? url,
      {bool allowDownload = false}) async {
    try {
      final response = await http.get(Uri.parse(url!));
      if (response.statusCode == 200) {
        final dir = allowDownload
            ? await getApplicationDocumentsDirectory() // User-accessible directory
            : await getTemporaryDirectory(); // Temp directory for viewing
        final fileName = url.split('/').last;
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        if (allowDownload) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File downloaded to: ${file.path}')),
          );
        }

        setState(() {
          localFilePath = file.path;
        });
      } else {
        throw Exception('Failed to download file: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
        return AlertDialog(
          title: const Text('Submit an Ad'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                      titleController, 'Ad Title', 'Please enter the ad title'),
                  _buildTextField(descriptionController, 'Description',
                      'Please enter a description'),
                  _buildDatePickerField(
                      context, startDateController, 'Start Date', selectDate),
                  _buildDatePickerField(
                      context, endDateController, 'End Date', selectDate),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  AdRequest businessData = AdRequest(
                    title: titleController.text,
                    description: descriptionController.text,
                    startDate: dateFormat
                        .format(DateTime.parse(startDateController.text)),
                    endDate: dateFormat
                        .format(DateTime.parse(endDateController.text)),
                  );

                  postAds(businessData).then((_) {
                    _showSuccessDialog(context);
                  }).catchError((error) {
                    _showErrorDialog(context, error.toString());
                  });
                }
              },
              child: const Text('Create'),
            ),
          ],
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
      readOnly: true, // Prevent manual typing
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
                'Contract',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF013803),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            if (selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Selected File: ${selectedFile!.path.split('/').last}',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green, // Outline color
                  width: 2.0, // Outline thickness
                ),
                borderRadius:
                    BorderRadius.circular(8), // Optional: Rounded corners
              ),
              child: SizedBox(
                height: 300,
                width: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: Future.delayed(const Duration(
                            seconds: 3)), // Show loading for 3 seconds
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            // Show CircularProgressIndicator for 3 seconds
                            return const Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.green, // Custom color
                                  strokeWidth: 6.0, // Thicker stroke
                                ),
                                SizedBox(height: 10),
                                Text("Loading, please wait...",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ],
                            ));
                          }

                          // After 3 seconds, check if the file exists
                          if (localFilePath == null) {
                            return const Center(
                              child: Text(
                                "No contract available",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            );
                          }

                          // If file exists, show the PDF
                          return PDFView(
                            filePath: localFilePath!,
                            enableSwipe: true,
                            swipeHorizontal: false,
                            autoSpacing: true,
                            pageFling: true,
                            onRender: (pages) {},
                            onError: (error) {},
                          );
                        },
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF013803),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Trigger file download
                        _downloadAndSaveFile(
                            '$devUrl${widget.house.contractUrl}',
                            allowDownload: true);
                      },
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                      label: const Text('Download'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF013803),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Upload File',
                style: TextStyle(fontSize: 16),
              ),
            ),
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

                  return SizedBox(
                    height:
                        500, // You can adjust this height based on your design
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to room details page
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: room.tenantId == 0
                                  ? Colors.transparent
                                  : (room.rentStatus
                                      ? const Color(0xFF158518)
                                      : const Color.fromARGB(255, 128, 14, 6)),
                              borderRadius: BorderRadius.circular(10),
                              border: room.tenantId == 0
                                  ? Border.all(
                                      color: const Color(0xFF158518), width: 2)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Room Name: ${room.roomName}\nBedrooms: ${room.noOfBedrooms}',
                                  style: TextStyle(
                                    color: room.tenantId == 0
                                        ? Colors
                                            .black // Change text color when container is transparent
                                        : Colors
                                            .white, // White text for colored backgrounds
                                  ),
                                ),
                                Text(
                                  'Bedrooms: ${room.noOfBedrooms}',
                                  style: TextStyle(
                                    color: room.tenantId == 0
                                        ? Colors
                                            .black // Change text color when container is transparent
                                        : Colors
                                            .white, // White text for colored backgrounds
                                  ),
                                ),
                                Text(
                                  'Rent: ${room.rentAmount}',
                                  style: TextStyle(
                                    color: room.tenantId == 0
                                        ? Colors
                                            .black // Change text color when container is transparent
                                        : Colors
                                            .white, // White text for colored backgrounds
                                  ),
                                ),
                                Text(
                                  'Tenant: ${room.tenantId}',
                                  style: TextStyle(
                                    color: room.tenantId == 0
                                        ? Colors
                                            .black // Change text color when container is transparent
                                        : Colors
                                            .white, // White text for colored backgrounds
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
                    builder: (context) => RoomInputPage(
                          apartmentId: widget.house.houseId,
                        )),
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
            child: const Icon(Icons.tv),
            label: 'Statistics',
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
                    Text(widget.house.location,
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
                    Text('\$${widget.house.rentAmount}',
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
                    Text('Caretaker ID: ${widget.house.caretakerId}',
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
