import 'package:flutter/material.dart';
import 'package:ikproject/features/main_page/presentation/user_screens/pages/user_main_page.dart';
import 'package:ikproject/features/asset_managment/presentation/user-screens/view/user_asset_managment.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/view/user_bonus_request.dart';
import 'package:ikproject/features/permission/presentation/user-screens/pages/history_of_permission_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  late String _email = '';
  late String? _role = '';

  List<Widget> get _tabs => [
    UserMainPage(email: _email,role: _role,),
    UserAssetManagment(),
    UserBonusRequest(),
    HistoryOfPermissionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onChangedArg(String email, String? role) {
    setState(() {
      _email = email;
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    (String, String?) arg =
        ModalRoute.of(context)!.settings.arguments as (String, String?);
    onChangedArg(arg.$1, arg.$2);
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        elevation: 0,
        backgroundColor: Colors.grey[300],
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Duyurular',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Zimmet'),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Avans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'İzin Talebi',
          ),
        ],
      ),
    );
  }
}
