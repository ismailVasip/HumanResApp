import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/singleton/get_admin_email.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/presentation/user_screens/bloc/user_main_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/intl.dart';

class UserMainPage extends StatelessWidget {
  final String _email;
  final String? _role;
  const UserMainPage({required String email, required String? role, super.key})
    : _email = email,
      _role = role;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserMainBloc>(),
      child: UserMainPageView(email: _email, role: _role),
    );
  }
}

class UserMainPageView extends StatefulWidget {
  final String _email;
  // ignore: unused_field
  final String? _role;
  const UserMainPageView({
    required String email,
    required String? role,
    super.key,
  }) : _email = email,
       _role = role;

  @override
  State<UserMainPageView> createState() => _UserMainPageViewState();
}

class _UserMainPageViewState extends State<UserMainPageView> {
  final double _headerHeight = 120;
  List<AnnouncementEntity> list = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    final email = await _getEmail();
    if (mounted) {
      context.read<UserMainBloc>().add(
        UserFetchAnnouncements(adminEmail: email ?? ''),
      );
    }
  }

  Future<String?> _getEmail() async {
    return await GetAdminEmail.instance.getAdminEmailForUser(widget._email);
  }

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
          'Duyurular',
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
      body: BlocConsumer<UserMainBloc, UserMainState>(
        listener: (context, state) {
          if (state is UserMainFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state is UserAnnouncementsFetched) {
            setState(() {
              list = state.list;
            });
          }
        },
        builder: (context, state) {
          return SizedBox.expand(
            child: Stack(
              children: [
                Container(
                  height: _headerHeight,
                  width: double.infinity,
                  color: Colors.black,
                ),
                SizedBox(
                  height: _headerHeight,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Hoşgeldin, ${widget._email}.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: _headerHeight - 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: list.isEmpty
                        ? SizedBox(
                            child: Center(
                              child: Text('Henüz duyuru yapılmadı.'),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return Card(
                                elevation: 2,
                                shadowColor: Colors.grey.withOpacity(0.2),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              'Duyuru',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        DateFormat(
                                          "dd.MM.yyyy",
                                        ).format(item.createdDate),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.details,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
