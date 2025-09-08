import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';

class AdminMainPage extends StatefulWidget {
  final String _email;
  final String? _role;
  const AdminMainPage({required String email, required String? role, super.key})
    : _email = email,
      _role = role;

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  final _gridItems = {
    'Çalışan Yönetimi': '/adminUpdateUserFinancials',
    'Çalışan Listesi': '/adminGetAllUsersPage',
    'Bildirimler': '/adminGetSupportsLineReqPage',
    'Duyuru Yap': '/adminCreateAnnouncementPage',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: Text(
          'Yönetim Paneli',
          style: const TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Çıkış Yap'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Merhaba',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget._email} (Rol:${widget._role})',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: _gridItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  var title = _gridItems.keys.elementAt(index);
                  var value = _gridItems[title];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        value ?? '',
                        arguments: widget._email,
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          Text(title, style: TextStyle(fontSize: 17)),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 27,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
