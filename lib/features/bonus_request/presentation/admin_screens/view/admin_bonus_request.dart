import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/admin_tabs.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/presentation/admin_screens/bloc/admin_bonus_bloc.dart';
import 'package:ikproject/features/bonus_request/presentation/admin_screens/widgets/admin_bonus_req_list.dart';
import 'package:ikproject/service_locator.dart';

class AdminBonusRequest extends StatelessWidget {
  const AdminBonusRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AdminBonusBloc>(),
      child: AdminBonusRequestView(),
    );
  }
}

class AdminBonusRequestView extends StatefulWidget {
  const AdminBonusRequestView({super.key});

  @override
  State<AdminBonusRequestView> createState() => _AdminBonusRequestViewState();
}

class _AdminBonusRequestViewState extends State<AdminBonusRequestView> {
  int _selectedTab = 0;
  List<AdvanceRequestEntity> _currentList = [];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<AdminBonusBloc>().add(
        AdminPendingRequestsFetch(adminEmail: authState.user.email!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Avans Talepleri', isBackButtonActive: false),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          spacing: 12,
          children: [
            AdminTabs(
              selectedTab: _selectedTab,
              onTabSelected: (value) {
                setState(() {
                  _selectedTab = value;
                });
              },
            ),
            BlocConsumer<AdminBonusBloc, AdminBonusState>(
              listener: (context, state) {
                if (state is AdminBonusFailure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is AdminUpdatedReqStatusSuccess) {
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
                final bool isLoading = state is AdminBonusLoading;

                if (state is AdminFetchedReqsSuccess) {
                  _currentList = state.list;
                }
                return Expanded(
                  child: AdminBonusReqList(
                    position: _selectedTab,
                    list: _currentList,
                    isLoading: isLoading,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
