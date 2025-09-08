import 'package:flutter/material.dart';

class SaveAnnualLimitButton extends StatelessWidget {
  final bool isLoading;
  final bool isTyped;
  final void Function()? onPressed;
  const SaveAnnualLimitButton({
    required this.isLoading,
    required this.isTyped,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ElevatedButton.icon(
        onPressed: isLoading || !isTyped ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(Icons.save),
        label: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : !isTyped
            ? Text(
                "Yıllık Limiti Giriniz",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : Text(
                "Kaydet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
