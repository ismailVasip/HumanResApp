import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/permission/presentation/user-screens/bloc/permission_block.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_permission_list_view.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_permission_tabs.dart';
import 'package:ikproject/service_locator.dart';

class HistoryOfPermissionPage extends StatelessWidget {
  const HistoryOfPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<PermissionBloc>(),
      child: HistoryOfPermissionPageView(),
    );
  }
}

class HistoryOfPermissionPageView extends StatefulWidget {
  const HistoryOfPermissionPageView({super.key});

  @override
  State<HistoryOfPermissionPageView> createState() =>
      _HistoryOfPermissionPageViewState();
}

class _HistoryOfPermissionPageViewState
    extends State<HistoryOfPermissionPageView> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<PermissionBloc>().add(
        MyPermissionsFetched(userEmail: authState.user.email!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          'İzin Talebi',
          style: const TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 40,
        actions: [
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.pushNamed(context, '/userAskForPermissionPage');
            },
            icon: Icon(Icons.add, size: 40, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            UserPermissionTabs(
              selectedTab: _selectedTab,
              onTabSelected: (index) => setState(() {
                _selectedTab = index;
              }),
            ),
            Expanded(
              child: BlocBuilder<PermissionBloc, PermissionState>(
                builder: (context, state) {
                  if (state is PermissionLoaded) {
                    return UserPermissionListView(
                      position: _selectedTab,
                      permissions: state.list,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
