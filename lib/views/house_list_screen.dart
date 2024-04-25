import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/get_house_service.dart';
import 'package:homi_2/views/house_details_screen.dart';

class HouseListScreen extends StatefulWidget {
  @override
  State<HouseListScreen> createState() => _HouseListScreenState();
}

class _HouseListScreenState extends State<HouseListScreen> {
  late Future<List<GetHouse>> futureHouses;

  @override
  void initState() {
    super.initState();
    futureHouses = fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House listings'),
      ),
      body: FutureBuilder(
          future: futureHouses,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    String baseUrl = 'http://127.0.0.1:8000';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseDetailsScreen(
                                house: snapshot.data![index]),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for (var imageUrl in snapshot.data![index].images)
                            if (snapshot.data![index].images.isNotEmpty)
                              Image.network(
                                '$baseUrl${snapshot.data![index].images[0]}',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                            if (snapshot.data![index].images.isEmpty)
                              const Placeholder(
                                fallbackHeight: 150,
                                fallbackWidth: double.infinity,
                              ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rent amount: ${snapshot.data![index].rent_amount}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Rating: ${snapshot.data![index].rating}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Location: ${snapshot.data![index].location}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
