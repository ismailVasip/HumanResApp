import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/create_admin_users/presentation/bloc/create_admin_bloc.dart';
import 'package:ikproject/service_locator.dart';

class CreateAdminUsersPage extends StatefulWidget {
  const CreateAdminUsersPage({super.key});

  @override
  State<CreateAdminUsersPage> createState() => _CreateAdminUsersPageState();
}

class _CreateAdminUsersPageState extends State<CreateAdminUsersPage> {
  final _formKeyForAssignment = GlobalKey<FormState>();
  final _formKeyForMatching = GlobalKey<FormState>();
  final TextEditingController _adminEmailForAssignmentController =
      TextEditingController();
  final TextEditingController _adminEmailForMatchingController =
      TextEditingController();
  final TextEditingController _userEmailForMatchingController =
      TextEditingController();

  @override
  void dispose() {
    _adminEmailForAssignmentController.dispose();
    _adminEmailForMatchingController.dispose();
    _userEmailForMatchingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    (String, String?) arg =
        ModalRoute.of(context)!.settings.arguments as (String, String?);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: Text(
          'Yönetici Atama',
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
              } else if (value == 'policy') {
                Navigator.pushNamed(
                  context,
                  '/superAdminCreateCompanyPolicyPage',
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'policy',
                child: Text('Şirket Politikaları'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Çıkış Yap'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => serviceLocator<CreateAdminBloc>(),
        child: BlocConsumer<CreateAdminBloc, CreateAdminState>(
          listener: (context, state) {
            if (state is CreateAdminFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
            }
            if (state is CreateAdminSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Başarıyla Yapıldı.'),
                    backgroundColor: Colors.green,
                  ),
                );
              _formKeyForAssignment.currentState?.reset();
              _adminEmailForAssignmentController.clear();
            }
            if (state is MatchAdminAndUserSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Başarıyla Yapıldı.'),
                    backgroundColor: Colors.green,
                  ),
                );
              _formKeyForMatching.currentState?.reset();
              _adminEmailForMatchingController.clear();
              _userEmailForMatchingController.clear();
            }
          },
          builder: (context, state) {
            final bool isLoadingForAssignment = state is CreateAdminLoading;
            final bool isLoadingForMatching = state is MatchAdminAndUserLoading;

            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Merhaba',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${arg.$1}(${arg.$2})',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKeyForAssignment,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            const Divider(thickness: 2, color: Colors.black),
                            const SizedBox(height: 12),
                            Text(
                              'Yönetici Atama',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _adminEmailForAssignmentController,
                              decoration: InputDecoration(hintText: 'E-posta'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Lütfen bir e-posta adresi giriniz.';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Lütfen geçerli bir e-posta adresi giriniz.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: isLoadingForAssignment
                                  ? null
                                  : () {
                                      if (_formKeyForAssignment.currentState!
                                          .validate()) {
                                        context.read<CreateAdminBloc>().add(
                                          CreateUserWithAdminRoleEvent(
                                            email:
                                                _adminEmailForAssignmentController
                                                    .text
                                                    .trim(),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoadingForAssignment
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'ATA',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKeyForMatching,
                        child: Column(
                          children: [
                            const Divider(thickness: 2, color: Colors.black),
                            const SizedBox(height: 12),
                            Text(
                              'Yönetici - Çalışan Eşleme',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _adminEmailForMatchingController,
                              decoration: InputDecoration(
                                hintText: 'Yönetici e-postası',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Lütfen bir e-posta adresi giriniz.';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Lütfen geçerli bir e-posta adresi giriniz.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _userEmailForMatchingController,
                              decoration: InputDecoration(
                                hintText: 'Çalışan e-postası',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Lütfen bir e-posta adresi giriniz.';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Lütfen geçerli bir e-posta adresi giriniz.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: isLoadingForMatching
                                  ? null
                                  : () {
                                      if (_formKeyForMatching.currentState!
                                          .validate()) {
                                        context.read<CreateAdminBloc>().add(
                                          MatchAdminAndUserEvent(
                                            adminEmail:
                                                _adminEmailForMatchingController
                                                    .text
                                                    .trim(),
                                            userEmail:
                                                _userEmailForMatchingController
                                                    .text
                                                    .trim(),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoadingForMatching
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'EŞLE',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
