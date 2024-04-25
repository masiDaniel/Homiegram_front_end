import 'package:flutter/material.dart';

class myTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final IconData? suffixIcon;
  final TextEditingController controller;

  const myTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.suffixIcon,
    required Null Function(dynamic value) onChanged,
  }) : super(key: key);

  @override
  _myTextFieldState createState() => _myTextFieldState();
}

class _myTextFieldState extends State<myTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 2, 2, 2)),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 255, 2, 2)),
            borderRadius: BorderRadius.circular(45.0),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  onPressed: _toggleObscureText,
                  icon: Icon(widget.suffixIcon),
                )
              : null,
        ),
      ),
    );
  }
}
