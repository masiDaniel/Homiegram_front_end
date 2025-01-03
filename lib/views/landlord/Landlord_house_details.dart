import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/models/get_users.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

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
        Uri.parse('http://127.0.0.1:8000/accounts/getUsers/'),
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
        Uri.parse('http://127.0.0.1:8000/houses/assign-caretaker/'),
        headers: headers,
        body: json.encode({
          'house_id': widget.house.HouseId,
          'user_id': selectedUser!.user_id,
        }),
      );

      if (response.statusCode == 200) {
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

  // Function to pick a file
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'], // Allow only PDF and TXT files
      );

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
        'Authorization': 'Bearer YOUR_TOKEN_HERE',
      };

      final uri = Uri.parse('http://127.0.0.1:8000/houses/uploadContract/');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields['house_id'] =
            widget.house.HouseId.toString() // Include the house ID
        ..files.add(await http.MultipartFile.fromPath(
          'contract_file', // Backend expects this key for the file
          selectedFile!.path,
        ));

      final response = await request.send();

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
            if (widget.house.caretaker_id == null)
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
              onPressed: _assignCaretaker,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Assign Caretaker',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
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
              'Rent: \$${widget.house.rent_amount}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'caretakert: \$${widget.house.caretaker_id}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
