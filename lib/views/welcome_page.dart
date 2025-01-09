import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homi_2/components/my_button.dart';

class WelcomePage extends StatelessWidget {
  ///
  /// this page holds the homigram animation together with,
  /// three buttons: login, signup and about us
  ///

  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypewriterAnimatedTextKit(
              text: const ["Homigram"],
              textStyle: GoogleFonts.aBeeZee(
                  color: const Color(0xFF126E06),
                  fontSize: 26,
                  fontWeight: FontWeight.w800),
              speed: const Duration(milliseconds: 300),
            ),
            const SizedBox(
              height: 50,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                MyButton(
                  buttonText: "Login",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  width: 90,
                  height: 40,
                  color: const Color(0xFF126E06),
                ),
                MyButton(
                  buttonText: "Sign Up",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  width: 90,
                  height: 40,
                  color: const Color(0xFF126E06),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            MyButton(
              buttonText: "About Us",
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              width: 300,
              height: 40,
              color: const Color(0xFF126E06),
            ),
          ],
        ),
      ),
    );
  }
}
