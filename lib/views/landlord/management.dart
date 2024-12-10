import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/landlord/Landlord_house_details.dart';
import 'package:homi_2/views/landlord/add_house.dart';

class LandlordManagement extends StatefulWidget {
  const LandlordManagement({super.key});

  @override
  State<LandlordManagement> createState() => _LandlordManagementState();
}

class _LandlordManagementState extends State<LandlordManagement> {
  late Future<List<GetHouse>> futureLandlordHouses;

  @override
  void initState() {
    super.initState();
    futureLandlordHouses = fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landlord Management'),
        leading: Container(),
      ),
      body: FutureBuilder<List<GetHouse>>(
        future: futureLandlordHouses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No houses available.'));
          }

          final houses = snapshot.data!;

          // Filter houses where the landlord_id matches the user ID
          final filteredHouses =
              houses.where((house) => house.landlord_id == userId).toList();

          return ListView.builder(
            itemCount: filteredHouses.length,
            itemBuilder: (context, index) {
              final house = filteredHouses[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the details page for managing the house
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HouseDetailsPage(house: house),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200, // Set the desired height for the image
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: house.images!.isNotEmpty
                                ? NetworkImage(
                                    '$devUrl${house.images?[0]}') // Online image
                                : const AssetImage('assets/images/splash.jpeg')
                                    as ImageProvider, // Local fallback image
                            fit: BoxFit.cover, // Adjust the image fitting
                          ),
                        ),
                      ),
                      Text(
                        house.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Rent: \$${house.rent_amount}'),
                      const SizedBox(height: 4),
                      Text('Location: ${house.location}'),
                      // Add more details as needed
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color.fromARGB(255, 24, 139, 7),
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_home),
            label: 'Add House',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHousePage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.tv),
            label: 'Advertise',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHousePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddHouseDialog() {
    // Show a dialog to add a house
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add House'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input fields for house details
              TextField(
                decoration: InputDecoration(labelText: 'House Name'),
              ),
              // Add more fields as necessary
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle adding house logic
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignCaretakerDialog() {
    // Show a dialog to assign a caretaker
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Caretaker'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input fields for caretaker details
              TextField(
                decoration: InputDecoration(labelText: 'Caretaker Name'),
              ),
              // Add more fields as necessary
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle assigning caretaker logic
                Navigator.of(context).pop();
              },
              child: const Text('Assign'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
