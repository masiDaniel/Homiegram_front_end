import 'package:flutter/material.dart';
import 'package:homi_2/components/my_snackbar.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class EditHouseDetailsPage extends StatefulWidget {
  const EditHouseDetailsPage({super.key});

  @override
  State<EditHouseDetailsPage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditHouseDetailsPage> {
  bool isEditing = false;
  bool isLoading = true;

  String houseName = '';
  String rentAmount = '';
  String description = '';
  String amenities = '';
  String bankName = '';
  String accountNumber = '';

  late TextEditingController houseNameController;
  late TextEditingController rentAmountController;
  late TextEditingController descriptionController;
  late TextEditingController amenitiesController;
  late TextEditingController bankNameController;
  late TextEditingController accountNumberController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveChanges() async {
    houseName = houseNameController.text;
    rentAmount = rentAmountController.text;
    description = descriptionController.text;
    amenities = amenitiesController.text;
    bankName = bankNameController.text;
    accountNumber = accountNumberController.text;

    final updatedData = {
      'name': houseName,
      'rent_amount': rentAmount,
      'description': description,
      'payment_bank_name': bankName,
      'payment_account_number': accountNumber,
    };
    await updateUserInfo(updatedData);
    await UserPreferences.savePartialUserData(updatedData);

    showCustomSnackBar(context, 'Profile updated!');
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit House details'),
        actions: [
          TextButton(
            onPressed: toggleEdit,
            child: Text(
              isEditing ? 'Save' : 'Edit',
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildField('House Name', houseNameController),
            _buildField('Rent Amount', rentAmountController),
            _buildField('description', descriptionController),
            _buildField('Bank Name', bankNameController),
            _buildField('Account Number', accountNumberController),
          ],
        ),
      ),
    );
  }
}
