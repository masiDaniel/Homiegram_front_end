import 'package:flutter/material.dart';
import 'package:homi_2/models/room.dart';
import 'package:homi_2/services/get_rooms_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class RentingPage extends StatefulWidget {
  const RentingPage({super.key});

  @override
  State<RentingPage> createState() => _RentingPageState();
}

class _RentingPageState extends State<RentingPage> {
  late Future<List<GetRooms>> futureRooms;

  @override
  void initState() {
    super.initState();
    futureRooms = fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renting Page'),
        leading: Container(),
      ),
      body: FutureBuilder<List<GetRooms>>(
        future: fetchRooms(), // The Future that fetches the list of rooms
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Loading indicator while waiting
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error display
          } else if (snapshot.hasData) {
            List<GetRooms>? rooms = snapshot.data; // Access the list of rooms

            // Find if there's a room where tenantId matches userId
            List<GetRooms> matchedRooms =
                rooms!.where((room) => room.tenantId == userId).toList();

            if (matchedRooms.isEmpty) {
              // No room found for the current user
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning, size: 100, color: Color(0xFF126E06)),
                      SizedBox(height: 20),
                      Text(
                        'You don\'t have a room assigned yet.',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Get a room now to access this service and enjoy seamless experience!\nHead over to the search page for multiple choices!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      // Look at get x for state management and stack for pages
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Add logic to direct user to rent a room page
                      //     Navigator.pushNamed(context, '/searchPage');
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: const Color(0xFF126E06)),
                      //   child: const Text(
                      //     'Find a Room',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            } else {
              // Room found for the current user
              return ListView.builder(
                itemCount: matchedRooms.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.home,
                                color: Color(0xFF126E06)),
                            title: const Text('Room ID'),
                            subtitle: Text('${matchedRooms[index].roomId}'),
                          ),
                          const Divider(),
                          ListTile(
                            leading:
                                const Icon(Icons.bed, color: Color(0xFF126E06)),
                            title: const Text('Bedrooms'),
                            subtitle:
                                Text('${matchedRooms[index].noOfBedrooms}'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.person,
                                color: Color(0xFF126E06)),
                            title: const Text('Tenant ID'),
                            subtitle: Text('${matchedRooms[index].tenantId}'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.monetization_on,
                                color: Color(0xFF126E06)),
                            title: const Text('Rent Amount'),
                            subtitle: Text('${matchedRooms[index].rentAmount}'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.payments,
                                color: Color(0xFF126E06)),
                            title: const Text('Rent Status'),
                            subtitle: Text('${matchedRooms[index].rentStatus}'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
                child: Text('No rooms available')); // If no data is returned
          }
        },
      ),
    );
  }
}
