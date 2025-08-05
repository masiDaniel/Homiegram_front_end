import 'package:flutter/material.dart';
import 'package:homi_2/components/my_snackbar.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class EditHouseDetailsPage extends StatefulWidget {
  final GetHouse house;
  const EditHouseDetailsPage({super.key, required this.house});

  @override
  State<EditHouseDetailsPage> createState() => _EditHouseDetailsPageState();
}

class _EditHouseDetailsPageState extends State<EditHouseDetailsPage> {
  bool isEditing = false;
  bool isLoading = true;

  String houseName = '';
  String rentAmount = '';
  String description = '';
  String bankName = '';
  String accountNumber = '';

  late TextEditingController houseNameController;
  late TextEditingController rentAmountController;
  late TextEditingController descriptionController;
  late TextEditingController bankNameController;
  late TextEditingController accountNumberController;

  // Track selected amenities
  late Set<int> selectedAmenities;

  // Example available amenities
  final Map<int, String> allAmenities = {
    1: "Wi-Fi",
    2: "Parking",
    3: "Water",
    4: "Security",
    5: "Laundry",
  };

  @override
  void initState() {
    super.initState();

    houseNameController = TextEditingController(text: widget.house.name);
    rentAmountController =
        TextEditingController(text: widget.house.rentAmount.toString());
    descriptionController =
        TextEditingController(text: widget.house.description);
    bankNameController =
        TextEditingController(text: widget.house.bankName ?? '');
    accountNumberController =
        TextEditingController(text: widget.house.accountNumber ?? '');

    selectedAmenities = widget.house.amenities != null
        ? Set<int>.from(widget.house.amenities)
        : <int>{};

    isLoading = false;
  }

  Future<void> _saveChanges() async {
    houseName = houseNameController.text;
    rentAmount = rentAmountController.text;
    description = descriptionController.text;
    bankName = bankNameController.text;
    accountNumber = accountNumberController.text;

    final updatedData = {
      'name': houseName,
      'rent_amount': rentAmount,
      'description': description,
      'payment_bank_name': bankName,
      'payment_account_number': accountNumber,
      'amenities': selectedAmenities.toList(),
    };

    await updateHouseInfo(updatedData, widget.house.houseId);
    if (!mounted) return;
    showCustomSnackBar(context, 'House details updated!');
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        _saveChanges();
      }
      isEditing = !isEditing;
    });
  }

  Widget _buildField(String label, TextEditingController controller) {
    return isEditing
        ? TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
          )
        : ListTile(
            title: Text(label),
            subtitle: Text(controller.text),
          );
  }

  Widget _buildAmenitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amenities',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...allAmenities.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.value),
              value: selectedAmenities.contains(entry.key),
              onChanged: isEditing
                  ? (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedAmenities.add(entry.key);
                        } else {
                          selectedAmenities.remove(entry.key);
                        }
                      });
                    }
                  : null,
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit House Details'),
        actions: [
          TextButton(
            onPressed: toggleEdit,
            child: Text(
              isEditing ? 'Save' : 'Edit',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildField('House Name', houseNameController),
            _buildField('Rent Amount', rentAmountController),
            _buildField('Description', descriptionController),
            _buildField('Bank Name', bankNameController),
            _buildField('Account Number', accountNumberController),
            const SizedBox(height: 16),
            _buildAmenitiesSection(),
          ],
        ),
      ),
    );
  }
}
