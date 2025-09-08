import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/bloc/a_main_page_bloc.dart';
import 'package:ikproject/service_locator.dart';

class AdminGetAllUsers extends StatelessWidget {
  final String adminEmail;
  const AdminGetAllUsers({required this.adminEmail, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AdminMainPageBloc>(),
      child: AdminGetAllUsersView(adminEmail: adminEmail),
    );
  }
}

class AdminGetAllUsersView extends StatefulWidget {
  final String adminEmail;
  const AdminGetAllUsersView({required this.adminEmail, super.key});

  @override
  State<AdminGetAllUsersView> createState() => _AdminGetAllUsersViewState();
}

class _AdminGetAllUsersViewState extends State<AdminGetAllUsersView> {
  List<UserEntity> list = [];
  bool _minTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    context.read<AdminMainPageBloc>().add(
      AdminFetchAllUsers(adminEmail: widget.adminEmail),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _minTimeElapsed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Çalışan Listesi', isBackButtonActive: true),
      body: BlocConsumer<AdminMainPageBloc, AMainPageState>(
        listener: (context, state) {
          if (state is AdminAllUsersFetched) {
            setState(() {
              list = state.list;
            });
          }
        },
        builder: (context, state) {
          bool isLoading = state is AdminMainPageGetUsersLoading;
          return isLoading || !_minTimeElapsed
              ? Center(child: CircularProgressIndicator(color: Colors.black,))
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Çalışan Sayısı : ${list.length}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: list.isEmpty
                            ? const SizedBox(
                                height: 140,
                                child: Center(
                                  child: Text(
                                    "Size atanmış çalışan bulunamadı!",
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final user = list[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade700,
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  bottomLeft: Radius.circular(
                                                    12,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            spacing: 3,
                                            children: [
                                              Text(
                                                "${user.fullName}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "E-posta: ${user.email}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Divider(
                                                color: Colors.blue,
                                                thickness: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
