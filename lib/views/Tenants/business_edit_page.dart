import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homi_2/components/my_snackbar.dart';
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
      showCustomSnackBar(context, "No Changes to update");
      return;
    }

    final url = Uri.parse(
        'http://your-api-domain.com/business/updateBusiness/${originalData['id']}/');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ',
      },
      body: jsonEncode(updates),
    );

    if (!mounted) return;
    if (response.statusCode == 200) {
      showCustomSnackBar(context, "Business updated successfully");
    } else {
      showCustomSnackBar(context, "Update failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Business")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Business Name'),
            ),
            TextFormField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Contact Number'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedLocation,
              decoration: const InputDecoration(labelText: 'Location'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Location 1')),
                DropdownMenuItem(value: 2, child: Text('Location 2')),
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
              decoration: const InputDecoration(labelText: 'Business Type'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Retail')),
                DropdownMenuItem(value: 2, child: Text('Wholesale')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedBusinessType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: updateBusiness,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
