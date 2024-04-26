import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';
import 'package:homi_2/models/user_signin.dart';
import 'package:homi_2/services/user_sigin_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final UserService _userService = UserService();

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    if (email.isNotEmpty && password.isNotEmpty && isValidEmail(email)) {
      UserRegistration? userRegistration =
          await fetchUserRegistration(email, password);
      if (userRegistration != null) {
        // Sign in successful, navigate to the homepage screen
        Navigator.pushNamed(context, '/homepage');
      } else {
        // Show error message if the sign-in was unsuccessful
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid email or password'),
        ));
      }
    } else {
      // Show error message if one or both of the fields are not inputted or email format is invalid
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid email and password'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0F2027),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign in",
                  style: GoogleFonts.carterOne(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 15),
                myTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                  suffixIcon: Icons.email,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 25),
                myTextField(
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
                      color: Colors.white,
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
                        color: Colors.orange,
                        fontSize: 10,
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
                  color: const Color.fromARGB(255, 71, 70, 70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
