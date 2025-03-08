import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homi_2/views/Tenants/home_page_v1.dart';
import 'package:homi_2/views/Tenants/market_place.dart';
import 'package:homi_2/views/Tenants/profile_page.dart';
import 'package:homi_2/views/Tenants/renting_page.dart';
import 'package:homi_2/views/Tenants/search_page.dart';
import 'package:homi_2/views/landlord/management.dart';

class CustomBottomNavigartion extends StatefulWidget {
  final String? userType; // Add a userType parameter
  const CustomBottomNavigartion({super.key, required this.userType});

  @override
  State<CustomBottomNavigartion> createState() => _HomePageState();
}

class _HomePageState extends State<CustomBottomNavigartion> {
  int _selectedIndex = 0;

  List<Widget> get _pages {
    // handling cases when usertype is null
    if ((widget.userType ?? 'tenant') == 'landlord') {
      return const [
        HomePage(),
        SearchPage(),
        MarketPlace(),
        LandlordManagement(),
        ProfilePage(),
      ];
    } else {
      return const [
        HomePage(),
        SearchPage(),
        MarketPlace(),
        RentingPage(),
        ProfilePage(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // Exit the app when back button is pressed
    SystemNavigator.pop(); // Works on Android
    return false; // Prevents default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // prevent back navigation accross all tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFFFF),
        body: _pages.elementAt(_selectedIndex), // Ensure the index is valid
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: 'search',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shop,
                color: Colors.black,
              ),
              label: 'Market',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.money,
                color: Colors.black,
              ),
              label: 'Rent',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: 'profile',
              backgroundColor: Colors.white,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF059205),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
