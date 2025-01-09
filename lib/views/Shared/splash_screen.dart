import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the WelcomePage after a delay of the desired time.
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// this works well for an image,
    /// how will i refactor for it to handle videos?
    /// or both
    ///
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.jpeg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
