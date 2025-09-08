import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/bloc/user_bonus_bloc.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/widget/determining_amount.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/widget/pick_a_reason.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/widget/summary_and_confirm.dart';
import 'package:ikproject/service_locator.dart';
import 'package:im_stepper/stepper.dart';

class AskBonusPage extends StatelessWidget {
  const AskBonusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserBonusBloc>(),
      child: AskBonusPageView(),
    );
  }
}

class AskBonusPageView extends StatefulWidget {
  const AskBonusPageView({super.key});

  @override
  State<AskBonusPageView> createState() => _AskBonusPageViewState();
}

class _AskBonusPageViewState extends State<AskBonusPageView> {
  int selectedIndex = 0;
  UserFinancialsEntity entity = UserFinancialsEntity(
    userEmail: '',
    annualLimit: 0.0,
    remainingLimit: 0.0,
  );
  List<String>? policyList = [];
  double autoApprovalMaxAmount = 0;
  int maxInstallments = 1;

  //
  String? _selectedReason;
  double? _selectedAmount;
  String? userEmail;
  bool isAutoApproved = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      context.read<UserBonusBloc>().add(UserFetchCompanyPolicy());
      context.read<UserBonusBloc>().add(
        UserGetFinancials(userEmail: authState.user.email!),
      );
      userEmail = authState.user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Yeni Avans İste', isBackButtonActive: true),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          NumberStepper(
            onStepReached: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            activeStep: selectedIndex,
            activeStepColor: Colors.black,
            activeStepBorderColor: Colors.transparent,
            lineColor: Colors.black,
            stepColor: Colors.blue,
            numberStyle: TextStyle(color: Colors.white),
            lineLength: 40,
            numbers: [1, 2, 3],
          ),
          BlocConsumer<UserBonusBloc, UserBonusState>(
            listener: (context, state) {
              if (state is UserFinancialsFetched) {
                entity = state.entity;
              }
              if (state is UserCompanyPolicyFetched) {
                policyList = state.entity.validReasons;
                autoApprovalMaxAmount =
                    state.entity.autoApprovalMaxAmount ?? 0.0;
                maxInstallments = state.entity.maxInstallments ?? 1;
              }
              if (state is UserBonusFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            builder: (context, state) {
              return Flexible(
                fit: FlexFit.loose,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(8),
                  child: IndexedStack(
                    index: selectedIndex,
                    children: [
                      PickAReasonWidget(
                        list: policyList,
                        onReasonChanged: (value) {
                          setState(() {
                            _selectedReason = value;
                          });
                        },
                      ),
                      DeterminingAmountWidget(
                        entity: entity,
                        autoApprovalMaxAmount: autoApprovalMaxAmount,
                        maxInstallments: maxInstallments,
                        onAmountChanged: (value) {
                          setState(() {
                            _selectedAmount = value;
                          });
                        },
                        onIsAutoApproveChanged: (value) {
                          setState(() {
                            isAutoApproved = value;
                          });
                        },
                      ),
                      SummaryAndConfirmWidget(
                        selectedReason: _selectedReason,
                        selectedAmount: _selectedAmount,
                        remainingLimit: entity.remainingLimit,
                        maxInstallments: maxInstallments,
                        userEmail: userEmail,
                        isAutoApproved: isAutoApproved,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
