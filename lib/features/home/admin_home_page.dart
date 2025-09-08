import 'package:flutter/material.dart';
import 'package:ikproject/features/asset_managment/presentation/admin-screens/view/admin_asset_managment.dart';
import 'package:ikproject/features/bonus_request/presentation/admin_screens/view/admin_bonus_request.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/pages/admin_main_page.dart';
import 'package:ikproject/features/permission/presentation/admin-screens/pages/request_of_permissions_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  late String _email = '';
  late String? _role = '';


  List<Widget> get _tabs => [
    AdminMainPage(email: _email,role: _role,),
    AdminAssetManagment(),
    AdminBonusRequest(),
    RequestOfPermissionsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void onChangedArg(String email,String? role){
    setState(() {
      _email = email;
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    (String,String?) arg = ModalRoute.of(context)!.settings.arguments as (String,String?);
    onChangedArg(arg.$1, arg.$2);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        backgroundColor: Colors.grey[300],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Yönetim Paneli',
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
