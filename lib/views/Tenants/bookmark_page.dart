import 'package:flutter/material.dart';
import 'package:homi_2/models/get_house.dart';
import 'package:homi_2/services/fetch_bookmarks.dart';
import 'package:homi_2/services/get_house_service.dart';

class BookmarkedHousesPage extends StatefulWidget {
  final int userId;

  BookmarkedHousesPage({required this.userId});

  @override
  _BookmarkedHousesPageState createState() => _BookmarkedHousesPageState();
}

class _BookmarkedHousesPageState extends State<BookmarkedHousesPage> {
  late Future<List<GetHouse>> _bookmarkedHousesFuture;

  @override
  void initState() {
    super.initState();
    _bookmarkedHousesFuture = _fetchBookmarkedHouses();
  }

  Future<List<GetHouse>> _fetchBookmarkedHouses() async {
    // Fetch the bookmarks for the user
    final bookmarks = await fetchBookmarks(widget.userId);

    // Extract the house IDs from the bookmarks
    final houseIds = bookmarks.map((bookmark) => bookmark.house).toList();
    fetchHouses();
    // Fetch the house details using the house IDs
    return await fetchHouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Houses')),
      body: FutureBuilder<List<GetHouse>>(
        future: _bookmarkedHousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final houses = snapshot.data!;
            return ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                final house = houses[index];
                return ListTile(
                  leading: Image.network(house.images as String,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(house.name),
                  subtitle: Text(house.description),
                  onTap: () {
                    // Navigate to house detail page or perform any other action
                    print('Clicked on house: ${house.name}');
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No bookmarked houses.'));
          }
        },
      ),
    );
  }
}
