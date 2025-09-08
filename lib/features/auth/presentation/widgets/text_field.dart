import 'package:flutter/material.dart';

class MyTextFormfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool showPassword;
  final Function()? showPasswordFunc;

  const MyTextFormfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.showPasswordFunc,
    this.showPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: showPassword ? false : obscureText ,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: obscureText ? IconButton(
            onPressed: showPasswordFunc,
            icon : showPassword ? Icon(Icons.lock_open) : Icon(Icons.lock)
          ) : null
        ),
        
      ),
    );
  }
}