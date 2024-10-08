import 'package:flutter/material.dart';
import 'package:homi_2/views/Shared/about_app.dart';
import 'package:homi_2/views/Tenants/Navigation_bar.dart';
import 'package:homi_2/views/Tenants/all_houses.dart';
import 'package:homi_2/views/Tenants/home_page_v1.dart';
import 'package:homi_2/views/Tenants/house_list_screen.dart';
import 'package:homi_2/views/sign_in.dart';
import 'package:homi_2/views/Shared/sign_up.dart';
import 'package:homi_2/views/welcome_page.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomiGram',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/about': (context) => AboutHomiegram(),
        '/homepage': (context) => const HomePage(),
        '/homescreen': (context) => const CustomBottomNavigartion(),
        '/allHouses': (context) => const allHouses(),
        '/trialAllHouses': (context) => HouseListScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(), // Handle unknown routes
        );
      },
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("not found"),
      ),
      body: Container(
        color: const Color(0xFF0b8793),
        height: 300,
        width: 300,
      ),
    );
  }
}

void navigateToPageAfterDelay(
    BuildContext context, String routeName, int delayInSeconds) {
  Future.delayed(Duration(seconds: delayInSeconds), () {
    Navigator.pushNamed(context, routeName);
  });
}
