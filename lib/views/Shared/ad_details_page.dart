import 'package:flutter/material.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class AdDetailPage extends StatelessWidget {
  final Ad ad;

  const AdDetailPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Ad Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ad.imageUrl != null
                  ? Image.network(
                      '$devUrl${ad.imageUrl!}',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/advertise.png',
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
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              ad.description,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Start Date: ${ad.startDate}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'End Date: ${ad.endDate}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
