import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/auth.png',
      fit: BoxFit.cover,
      width: 100,
      height: 100,
    );
  }
}
