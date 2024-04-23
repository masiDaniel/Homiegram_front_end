import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';

class HouseDetailsScreen extends StatelessWidget {
  final GetHouse house;

  const HouseDetailsScreen({required this.house});

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      appBar: AppBar(
        title: Text(house.name),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var imageUrl in house.images)
                Image.network(
                  '$baseUrl$imageUrl',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                )
            ],
          )),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'description: ${house.description}',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text('rent amount: ${house.rent_amount}'),
                Text('rating: ${house.rating}'),
                Text('location: ${house.location}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
