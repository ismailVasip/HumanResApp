import 'package:flutter/material.dart';

class SearchUserButton extends StatelessWidget {
  final bool isLoadingForSearch;
  final bool isEmailTyped;
  final void Function()? onPressed;
  const SearchUserButton({
    required this.isLoadingForSearch,
    required this.isEmailTyped,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ElevatedButton(
        onPressed: isLoadingForSearch || !isEmailTyped ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoadingForSearch
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : !isEmailTyped
            ? Text(
                "E-Posta Giriniz",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : const Text(
                'Ara',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
