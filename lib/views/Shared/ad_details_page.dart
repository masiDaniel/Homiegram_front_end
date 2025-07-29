import 'package:flutter/material.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class AdDetailPage extends StatelessWidget {
  final Ad ad;

  const AdDetailPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text("Ad Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                '$devUrl${ad.imageUrl!}',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              ad.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              ad.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Start Date: ${ad.startDate}',
              style: const TextStyle(fontSize: 14, color: Colors.white60),
            ),
            const SizedBox(height: 5),
            Text(
              'End Date: ${ad.endDate}',
              style: const TextStyle(fontSize: 14, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
