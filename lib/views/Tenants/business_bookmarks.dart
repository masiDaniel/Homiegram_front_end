import 'package:flutter/material.dart';

class BusinessBookmarks extends StatefulWidget {
  const BusinessBookmarks({super.key});

  @override
  State<BusinessBookmarks> createState() => _BusinessBookmarksState();
}

class _BusinessBookmarksState extends State<BusinessBookmarks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookmark'),
        // No need to add a back button manually as it appears by default.
      ),
      body: const Center(
        child: Text('your Bookmarks'),
      ),
    );
  }
}
