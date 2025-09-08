import 'package:flutter/material.dart';

class UserCauseInputField extends StatelessWidget {
  final TextEditingController controller;
  const UserCauseInputField({required this.controller,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(Icons.abc_rounded, color: Colors.blue, size: 30),
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'Açıklama',
              labelStyle: TextStyle(
                fontSize: 14
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
