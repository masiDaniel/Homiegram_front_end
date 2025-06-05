import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homi_2/components/my_button.dart';
import 'package:homi_2/components/my_text_field.dart';
import 'package:homi_2/models/user_signup.dart';
import 'package:homi_2/services/user_signup_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  void _signUserUp() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    bool isValidMandatoryEmail(String email) {
      final RegExp regex = RegExp(r"^[\w\.-]+@gmail\.com$");
      return regex.hasMatch(email);
    }

    if (!isValidMandatoryEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid. (Valid) Email format gmail.com')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserSignUp? userSignUp =
          await fetchUserSignUp(firstName, lastName, email, password);
      if (userSignUp != null) {
        if (!mounted) return;
        Navigator.pushNamed(context, '/signin');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Sign-up failed. Please try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: GoogleFonts.carterOne(
                    color: const Color(0xFF126E06),
                    fontSize: 50,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: firstNameController,
                hintText: "First name",
                obscureText: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: lastNameController,
                hintText: "Last name",
                obscureText: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                suffixIcon: Icons.email,
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
                suffixIcon: Icons.password,
                onChanged: (value) {},
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
                suffixIcon: Icons.password,
                onChanged: (value) {},
              ),
              const SizedBox(height: 45),
              isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF126E06))
                  : MyButton(
                      buttonText: "Sign Up",
                      onPressed: _signUserUp,
                      width: 150,
                      height: 40,
                      color: const Color(0xFF126E06)),
              const SizedBox(height: 15),
              const Text("Already have an account?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/signin'),
                child: const Text("Sign in",
                    style: TextStyle(
                        color: Color(0xFF126E06),
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
