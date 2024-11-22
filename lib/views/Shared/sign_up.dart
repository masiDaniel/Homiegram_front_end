import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';
import 'package:homi_2/models/user_signup.dart';
import 'package:homi_2/services/user_signup_service.dart';

class SignUp extends StatefulWidget {
  ///
  /// this page deals with the ui for signing up
  /// once succesfully signed up the user is redirected to the sign in page
  /// at the bottom there is the feature of signing up with google
  /// i dont understand the SignUserIn function
  ///
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpaswordController =
      TextEditingController();

  void _signUserUp() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailContoller.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmpaswordController.text.trim();

    /// method to check if the email structure is valid
    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    /// method to check if passwords match
    bool isPasswordMatch(String password, confirmPassword) {
      return password == confirmPassword;
    }

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        isValidEmail(email) &&
        isPasswordMatch(password, confirmPassword)) {
      UserSignUp? userSignUp =
          await fetchUserSignUp(firstName, lastName, email, password);

      if (userSignUp != null) {
        // Sign in successful, navigate to the dignup screen
        Navigator.pushNamed(context, '/signin');
      } else {
        // Show error messageif the sign in was unsuccesful
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occured during signing in, try again later'),
        ));
      }
    } else {
      // Show error message if one or either of the fields in not inputed
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all the fields in appropriate format'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: GoogleFonts.carterOne(
                  color: Color(0xFF126E06),
                  fontSize: 50,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 15,
            ),
            myTextField(
              controller: firstNameController,
              hintText: "First name",
              obscureText: false,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 15,
            ),
            myTextField(
              controller: lastNameController,
              hintText: "Last name",
              obscureText: false,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 15,
            ),
            myTextField(
              controller: emailContoller,
              hintText: "Email",
              obscureText: false,
              suffixIcon: Icons.email,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 15,
            ),
            myTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
              suffixIcon: Icons.password,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 15,
            ),
            myTextField(
              controller: confirmpaswordController,
              hintText: "password confirmation",
              obscureText: true,
              suffixIcon: Icons.password,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 45,
            ),
            MyButton(
              buttonText: "Sign Up",
              onPressed: _signUserUp,
              width: 150,
              height: 40,
              color: const Color(0xFF126E06),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Already have an account?  ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: const Text(
                " sign in",
                style: TextStyle(
                  color: Color(0xFF126E06),
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
