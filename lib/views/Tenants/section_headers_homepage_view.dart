import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:homi_2/views/Tenants/house_views.dart';

class SectionHeders extends StatelessWidget {
  final String headerTitle;

  const SectionHeders({super.key, this.headerTitle = "homie Houses"});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Text(
                headerTitle,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  log("button clicked");
                },
                icon: const Icon(
                  Icons.more_horiz,
                  size: 28,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const HousesView(),
      ],
    );
  }
}
