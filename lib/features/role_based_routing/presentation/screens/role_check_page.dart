import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/role_based_routing/domain/usecases/get_role_usecase.dart';
import 'package:ikproject/features/role_based_routing/presentation/cubit/role_cubit.dart';
import 'package:ikproject/features/role_based_routing/presentation/cubit/role_state.dart';
import 'package:ikproject/service_locator.dart';

class RoleCheckPage extends StatefulWidget {
  const RoleCheckPage({super.key});

  @override
  State<RoleCheckPage> createState() => _RoleCheckPageState();
}

class _RoleCheckPageState extends State<RoleCheckPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RoleCubit(getRoleUsecase: serviceLocator<GetRoleUsecase>())
            ..getUserRole(),
      child: Scaffold(
        body: BlocConsumer<RoleCubit, RoleState>(
          listener: (context, state) {
            if (state is RoleLoaded) {
              if (state.role == "super_admin") {
                Navigator.pushReplacementNamed(
                  context,
                  '/superAdminPage',
                  arguments: (state.email, state.role),
                );
              } else if (state.role == "admin") {
                Navigator.pushReplacementNamed(
                  context,
                  '/adminHomePage',
                  arguments: (state.email, state.role),
                );
              } else if (state.role == "user") {
                Navigator.pushReplacementNamed(
                  context,
                  '/userHomePage',
                  arguments: (state.email, state.role),
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  '/unknown',
                  arguments: (state.email, state.role),
                );
              }
            } else if (state is RoleError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is RoleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text("..."));
          },
        ),
      ),
    );
  }
}
