import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';
import 'package:homi_2/models/user_signin.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Tenants/navigation_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  /// this is a function that takes the input from the textfields and processes it
  /// once processed it calls the fetchUserRegistration with email and password as required parameters
  /// it stores the value returned in the userRegistration object and redirects the user to the homepage if succesful
  /// questions - (userRegistration class object?  what does the ? mean and do?)
  ///

  @override
  void initState() {
    super.initState();
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    if (email.isNotEmpty && password.isNotEmpty && isValidEmail(email)) {
      setState(() {
        _isLoading = true;
      });
      try {
        print("we have gotten into the begining ");
        UserRegistration? userRegistration =
            await fetchUserSignIn(email, password)
                .timeout(const Duration(seconds: 10), onTimeout: () {
          throw TimeoutException("Connection timed out. Please try again.");
        });
        print("this is the user registration object $userRegistration");

        if (userRegistration != null) {
          print("we are inside the valid response");
          if (!mounted) return;
          String? usertypeShared = await UserPreferences.getUserType();

          print("this is the user type $usertypeShared");

          // Navigator.pushReplacementNamed(context, '/homescreen');

          if (!mounted) return;
          {
            print("we are navigating to the home page");

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomBottomNavigartion()),
              (Route<dynamic> route) =>
                  false, // This removes all the previous routes
            );
          }
        } else {
          if (!mounted) return;
          print("we are outside the valid response");

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Invalid email or password'),
          ));
        }
      } on TimeoutException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? 'Request timed out'),
        ));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid email and password'),
      ));
    }
  }

  /// this part deals with the user interface of the sign in page
  /// it also  has the custom text fields that take input
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign in",
                    style: GoogleFonts.carterOne(
                        color: const Color(0xFF126E06),
                        fontSize: 50,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    suffixIcon: Icons.email,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    suffixIcon: Icons.password,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Dont' have an account?  ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      " sign up",
                      style: TextStyle(
                          color: Color(0xFF126E06),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    buttonText: 'Sign In',
                    onPressed: _signIn,
                    width: 150,
                    height: 40,
                    color: const Color(0xFF126E06),
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF126E06)),
                ),
              ),
            ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
