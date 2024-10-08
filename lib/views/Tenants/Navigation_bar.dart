import 'package:flutter/material.dart';
import 'package:homi_2/views/Tenants/home_page_v1.dart';
import 'package:homi_2/views/Tenants/market_place.dart';
import 'package:homi_2/views/Tenants/profile_page.dart';
import 'package:homi_2/views/Tenants/renting_page.dart';
import 'package:homi_2/views/Tenants/search_page.dart';

class CustomBottomNavigartion extends StatefulWidget {
  const CustomBottomNavigartion({super.key});

  @override
  State<CustomBottomNavigartion> createState() => _HomePageState();
}

class _HomePageState extends State<CustomBottomNavigartion> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const SearchPage(),
    const MarketPlace(),
    const RentingPage(),
    const ProfilePage(),
  ];

  // static final List<Widget> _pagesLandlord = <Widget>[
  //   const HomePage(),
  //   const SearchPage(),
  //   const MarketPlace(),
  //   const RentingPage(),
  //   const ProfilePage(),
  //   const LandingPage(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        selectedItemColor: Color.fromARGB(255, 5, 146, 5),
        onTap: _onItemTapped,
      ),
    );
  }
}
