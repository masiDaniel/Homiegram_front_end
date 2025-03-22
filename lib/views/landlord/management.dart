import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/landlord/landlord_house_details.dart';
import 'package:homi_2/views/landlord/add_house.dart';
import 'package:lottie/lottie.dart';

class LandlordManagement extends StatefulWidget {
  const LandlordManagement({super.key});

  @override
  State<LandlordManagement> createState() => _LandlordManagementState();
}

class _LandlordManagementState extends State<LandlordManagement> {
  late Future<List<GetHouse>> futureLandlordHouses;
  int? userIdShared;

  @override
  void initState() {
    super.initState();
    futureLandlordHouses = fetchHouses();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    int? id = await UserPreferences.getUserId();
    setState(() {
      userIdShared = id ?? 0; // Default to 'tenant' if null
    });
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
            return const Center(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.green, // Custom color
                    strokeWidth: 6.0, // Thicker stroke
                  ),
                  SizedBox(height: 10),
                  Text("Loading, please wait...",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              )),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Lottie.asset(
                'assets/animations/notFound.json', // Path to your animation file
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No houses available.'));
          }

          final houses = snapshot.data!;

          // Filter houses where the landlord_id matches the user ID
          final filteredHouses = houses
              .where((house) => house.landlordId == userIdShared)
              .toList();

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
                      Text('Rent: Ksh${house.rentAmount}'),
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
            child: const Icon(Icons.add_home),
            label: 'Add House',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddHousePage()),
              );
            },
          ),
          // SpeedDialChild(
          //   child: const Icon(Icons.tv),
          //   label: 'Advertise',
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const AddHousePage()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
