import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:marquee/marquee.dart';
import 'package:homi_2/components/my_button.dart';

class WelcomePage extends StatelessWidget {
  ///
  /// this page was supposed to be what is displayed as the splash screen
  /// i have not been able to implement this but im keen on doing this
  /// i will have Homiegram as an animation and a small desciption of what the application has to offer
  /// it has two buttons that will be
  /// login which redirects the user to the sign in page
  /// and sign up which will redirect them to the sign up page
  ///
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

            /// wraping this row with a widget that will ebsure that there is no
            /// overflow
            ///
            Wrap(
              spacing: 10.0,
              alignment: WrapAlignment.center,
              children: [
                MyButton(
                  buttonText: "Login!",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  width: 100,
                  height: 40,
                  color: const Color(0xFF126E06),
                ),
                MyButton(
                  buttonText: "Sign Up!",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  width: 100,
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
              width: 100,
              height: 40,
              color: const Color(0xFF126E06),
            ),
          ],
        ),
      ),
    );
  }
}
