import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  final String fullName;
  final String email;
  const UserDetails({required this.fullName, required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              "Çalışan Bilgileri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text(fullName),
              subtitle: Text("Ad Soyad"),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text(email),
              subtitle: Text("E-posta"),
            ),
          ],
        ),
      ),
    );
  }
}
