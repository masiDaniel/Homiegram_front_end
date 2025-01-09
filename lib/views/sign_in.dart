import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';
import 'package:homi_2/models/user_signin.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// this is a function that takes the input from the textfields and processes it
  /// once processed it calls the fetchUserRegistration with email and password as required parameters
  /// it stores the value returned in the userRegistration object and redirects the user to the homepage if succesful
  /// questions - (userRegistration class object?  what does the ? mean and do?)
  ///

  bool _isLoading = false;
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
        UserRegistration? userRegistration =
            await fetchUserSignIn(email, password);
        if (userRegistration != null) {
          // Check if the widget is still mounted before using the context
          if (!mounted) return;
          //navigate to the homepage screen if sign in is succesfull
          Navigator.pushNamed(context, '/homescreen');
        } else {
          // Check if the widget is still mounted before using the context
          if (!mounted) return;
          // Show error message if the sign-in was unsuccessful
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Invalid email or password'),
          ));
        }
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    } else {
      // Show error message if one or both of the fields are not inputted or email format is invalid
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
}
