import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool isBackButtonActive;
  const MyAppBar({
    super.key,
    required this.title,
    required this.isBackButtonActive
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.zero,
      child: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        leading: !isBackButtonActive ? 
          null :
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

  }
}