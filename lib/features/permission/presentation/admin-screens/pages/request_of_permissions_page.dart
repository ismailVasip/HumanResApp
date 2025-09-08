import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/admin_tabs.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/presentation/admin-screens/bloc/admin_permission_bloc.dart';
import 'package:ikproject/features/permission/presentation/admin-screens/widgets/a_permission_list_view.dart';
import 'package:ikproject/service_locator.dart';

class RequestOfPermissionsPage extends StatelessWidget {
  const RequestOfPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AdminPermissionBloc>(),
      child: _RequestOfPermissionsPageView(),
    );
  }
}

class _RequestOfPermissionsPageView extends StatefulWidget {
  const _RequestOfPermissionsPageView();

  @override
  State<_RequestOfPermissionsPageView> createState() =>
      _RequestOfPermissionsPageViewState();
}

class _RequestOfPermissionsPageViewState
    extends State<_RequestOfPermissionsPageView> {
  int _selectedTab = 0;
  List<PermissionEntity> _currentList = [];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<AdminPermissionBloc>().add(
        AllPermissionsFetched(adminEmail: authState.user.email!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'İzin Talepleri', isBackButtonActive: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              AdminTabs(
                selectedTab: _selectedTab,
                onTabSelected: (index) => setState(() => _selectedTab = index),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocConsumer<AdminPermissionBloc, AdminPermissionState>(
                  listener: (context, state) {
                    if (state is AdminPermissionFailure) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                    }
                    if (state is AdminActionSuccess) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                    }
                  },
                  builder: (context, state) {
                    final bool isLoading = state is AdminPermissionLoading;
        
                    if (state is AdminAllPermissionsLoaded) {
                      _currentList = state.list;
                      
                    }
                    return AdminPermissionListView(
                        position: _selectedTab,
                        permissions: _currentList,
                       isLoading:isLoading
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
