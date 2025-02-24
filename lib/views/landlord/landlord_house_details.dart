import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/get_users.dart';
import 'package:homi_2/services/get_rooms_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/landlord/addRoom.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

    try {
      // Define your headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $authToken',
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

    try {
      // Define your headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $authToken',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning caretaker: $e')),
      );
    }
  }

  Future<void> _removeCaretaker() async {
    try {
      // Define headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $authToken',
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
      var requestBody = json.encode({
        'house_id': widget.house.houseId,
        'caretaker_id': widget.house.caretakerId,
      });
      print("this is the body $requestBody");

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

    try {
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Token $authToken',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> _downloadAndSaveFile(String? url,
      {bool allowDownload = false}) async {
    try {
      print('Downloading from: $url');
      final response = await http.get(Uri.parse(url!));
      if (response.statusCode == 200) {
        final dir = allowDownload
            ? await getApplicationDocumentsDirectory() // User-accessible directory
            : await getTemporaryDirectory(); // Temp directory for viewing
        final fileName = url.split('/').last;
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        if (allowDownload) {
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
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                'Upload Contract',
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(fontSize: 16),
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
            SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Expanded(
                    child: localFilePath == null
                        ? const Center(child: CircularProgressIndicator())
                        : PDFView(
                            filePath: localFilePath!,
                            enableSwipe: true, // Enable swipe gestures
                            swipeHorizontal:
                                false, // Set to true for horizontal scrolling
                            autoSpacing: true, // Adds spacing between pages
                            pageFling: true, // Smooth page transitions
                            onRender: (pages) {
                              print('PDF Rendered with $pages pages');
                            },
                            onError: (error) {
                              print('Error loading PDF: $error');
                            },
                          ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Trigger file download
                      _downloadAndSaveFile('$devUrl${widget.house.contractUrl}',
                          allowDownload: true);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _uploadFile,
              style: ElevatedButton.styleFrom(
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
                backgroundColor:
                    isCaretakerAssigned ? Colors.red : Colors.green,
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
        backgroundColor: const Color.fromARGB(255, 24, 139, 7),
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add_home),
            label: 'Add Room',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomInputPage()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.tv),
            label: 'Advertise',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AddHousePage()),
              // );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.tv),
            label: 'Statistics',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AddHousePage()),
              // );
            },
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.house.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${widget.house.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Rent: \$${widget.house.rentAmount}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'caretakert: \$${widget.house.caretakerId}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
