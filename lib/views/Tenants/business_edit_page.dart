import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusinessEditPage extends StatefulWidget {
  final Map<String, dynamic> business;

  const BusinessEditPage({super.key, required this.business});

  @override
  State<BusinessEditPage> createState() => _BusinessEditPageState();
}

class _BusinessEditPageState extends State<BusinessEditPage> {
  late TextEditingController nameController;
  late TextEditingController contactController;
  late TextEditingController emailController;

  late int selectedLocation;
  late int selectedBusinessType;

  late Map<String, dynamic> originalData;

  @override
  void initState() {
    super.initState();

    originalData = Map.from(widget.business);

    nameController = TextEditingController(text: originalData['name']);
    contactController =
        TextEditingController(text: originalData['contact_number']);
    emailController = TextEditingController(text: originalData['email']);

    selectedLocation = originalData['location'];
    selectedBusinessType = originalData['business_type'];
  }

  Future<void> updateBusiness() async {
    Map<String, dynamic> updates = {};

    if (nameController.text != originalData['name']) {
      updates['name'] = nameController.text;
    }
    if (contactController.text != originalData['contact_number']) {
      updates['contact_number'] = contactController.text;
    }
    if (emailController.text != originalData['email']) {
      updates['email'] = emailController.text;
    }
    if (selectedLocation != originalData['location']) {
      updates['location'] = selectedLocation;
    }
    if (selectedBusinessType != originalData['business_type']) {
      updates['business_type'] = selectedBusinessType;
    }

    if (updates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No changes to update")),
      );
      return;
    }

    final url = Uri.parse(
        'http://your-api-domain.com/business/updateBusiness/${originalData['id']}/');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token your_token_here', // Add your token
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Business updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Business")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Business Name'),
            ),
            TextFormField(
              controller: contactController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedLocation,
              decoration: InputDecoration(labelText: 'Location'),
              items: [
                DropdownMenuItem(value: 1, child: Text('Location 1')),
                DropdownMenuItem(value: 2, child: Text('Location 2')),
                // Add more from your actual backend list
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLocation = value;
                  });
                }
              },
            ),
            DropdownButtonFormField<int>(
              value: selectedBusinessType,
              decoration: InputDecoration(labelText: 'Business Type'),
              items: [
                DropdownMenuItem(value: 1, child: Text('Retail')),
                DropdownMenuItem(value: 2, child: Text('Wholesale')),
                // Add more from your actual backend list
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedBusinessType = value;
                  });
                }
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: updateBusiness,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
