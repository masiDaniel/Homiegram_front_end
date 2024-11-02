import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';

class HouseDetailsPage extends StatelessWidget {
  final GetHouse house;

  const HouseDetailsPage({Key? key, required this.house}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(house.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('House Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Location: ${house.location}'),
            Text('Rent: \$${house.rent_amount}'),
            // Add more details as needed
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement logic to assign caretakers
              },
              child: const Text('Assign Caretakers'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement logic to approve actions
              },
              child: const Text('Approve Actions'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement logic to approve actions
              },
              child: const Text('Tenants'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement logic to approve actions
              },
              child: const Text('other activities'),
            ),
          ],
        ),
      ),
    );
  }
}
