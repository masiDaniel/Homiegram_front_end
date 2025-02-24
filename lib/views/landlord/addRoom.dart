import 'package:flutter/material.dart';
import 'package:homi_2/models/room.dart';
import 'package:homi_2/services/get_rooms_service.dart';

class RoomInputPage extends StatefulWidget {
  @override
  _RoomInputPageState createState() => _RoomInputPageState();
}

class _RoomInputPageState extends State<RoomInputPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _numberOfBedroomsController =
      TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();

  Future<void> _postRoomData() async {
    if (!_formKey.currentState!.validate()) return;

    final newRoom = GetRooms(
      roomId: 0, // Default since it's auto-generated in backend
      roomName: _roomNameController.text.trim(),
      noOfBedrooms: int.parse(_numberOfBedroomsController.text),
      sizeInSqMeters: _sizeController.text.trim(),
      rentAmount: _rentController.text.trim(),
      occuiedStatus: false,
      roomImages: '',
      apartmentID: int.parse(_apartmentController.text),
      tenantId: 0,
      rentStatus: false,
    );

    try {
      await postRoomsByHouse(_apartmentController.text as int, newRoom);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room posted successfully!')),
      );
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _clearForm() {
    _roomNameController.clear();
    _numberOfBedroomsController.clear();
    _sizeController.clear();
    _rentController.clear();
    _apartmentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Input Page')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_roomNameController, 'Room Name'),
              _buildTextField(_numberOfBedroomsController, 'Number of Bedrooms',
                  isNumeric: true),
              _buildTextField(_sizeController, 'Size (in sq meters)'),
              _buildTextField(_rentController, 'Rent Amount', isNumeric: true),
              _buildTextField(_apartmentController, 'Apartment ID',
                  isNumeric: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _postRoomData,
                child: const Text('Submit Room Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.trim().isEmpty)
            return 'This field is required';
          if (isNumeric && int.tryParse(value) == null)
            return 'Enter a valid number';
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _numberOfBedroomsController.dispose();
    _sizeController.dispose();
    _rentController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }
}
