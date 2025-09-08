import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/bloc/a_main_page_bloc.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/widgets/email_field.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/widgets/financial_details.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/widgets/save_annual_limit_button.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/widgets/search_user_button.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/widgets/user_details.dart';
import 'package:ikproject/service_locator.dart';

class UserFinancials extends StatelessWidget {
  const UserFinancials({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AdminMainPageBloc>(),
      child: UserFinancialsView(),
    );
  }
}

class UserFinancialsView extends StatefulWidget {
  const UserFinancialsView({super.key});

  @override
  State<UserFinancialsView> createState() => _UserFinancialsViewState();
}

class _UserFinancialsViewState extends State<UserFinancialsView> {
  final TextEditingController _emailController = TextEditingController();

  late TextEditingController _annualLimitController;
  late TextEditingController _remainingLimitController;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  UserEntity user = UserEntity(
    fullName: '',
    email: '',
    role: [],
    financials: {},
  );

  bool isEmailTyped = false;
  bool isAnnualLimitTyped = false;
  bool isUserDetailsShow = false;
  String? lastUserEmail;

  @override
  void initState() {
    super.initState();
    _annualLimitController = TextEditingController();
    _remainingLimitController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _annualLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Çalışan Yönetimi',
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 36, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AdminMainPageBloc, AMainPageState>(
          listener: (context, state) {
            if (state is AdminMainPageFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );

                setState(() {
                  isUserDetailsShow = false;
                });
            }
            if (state is AdminMainPageActionSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              _annualLimitController.clear();
              _remainingLimitController.clear();
              _key.currentState!.reset();

              context.read<AdminMainPageBloc>().add(
                AdminUserLoaded(
                  adminEmail: adminEmail,
                  userEmail: lastUserEmail!,
                ),
              );

              setState(() {
                isAnnualLimitTyped = false;
              });
            }
            if (state is AdminMainPageUserFetched) {
              setState(() {
                isUserDetailsShow = true;
                lastUserEmail = state.user.email;
                user = state.user;
                _annualLimitController.text =
                    user.financials?['annualLimit']?.toString() ?? '';
                _remainingLimitController.text =
                    user.financials?['remainingLimit']?.toString() ?? '';
              });
            }
          },
          builder: (context, state) {
            bool isLoadingForSearch = state is AdminMainPageSearchUserLoading;
            bool isLoadingForUpdate =
                state is AdminMainPageUpdateFinancialLoading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      //text - search employee
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Çalışan Ara',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //email
                      EmailField(
                        emailController: _emailController,
                        onEmailTyped: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              isEmailTyped = true;
                            });
                          } else {
                            setState(() {
                              isEmailTyped = false;
                            });
                          }
                        },
                      ),

                      //search-button
                      SearchUserButton(
                        isLoadingForSearch: isLoadingForSearch,
                        isEmailTyped: isEmailTyped,
                        onPressed: () {
                          context.read<AdminMainPageBloc>().add(
                            AdminUserLoaded(
                              adminEmail: adminEmail,
                              userEmail: _emailController.text.trim(),
                            ),
                          );
                        },
                      ),

                      Flexible(
                        fit: FlexFit.loose,
                        child: isUserDetailsShow
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //user-details
                                  UserDetails(
                                    fullName: user.fullName ?? "",
                                    email: user.email ?? "",
                                  ),

                                  // Financial-details
                                  FinancialDetails(
                                    annualLimitController:
                                        _annualLimitController,
                                    remainingLimitController:
                                        _remainingLimitController,
                                    valueChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          isAnnualLimitTyped = true;
                                        });
                                      } else {
                                        setState(() {
                                          isAnnualLimitTyped = false;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      final onlyDigits = RegExp(r'^\d+$');
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Bir değer giriniz!';
                                      }
                                      if (!onlyDigits.hasMatch(value)) {
                                        return 'Sadece rakam girin';
                                      }

                                      return null;
                                    },
                                  ),

                                  // save - button
                                  SaveAnnualLimitButton(
                                    isLoading: isLoadingForUpdate,
                                    isTyped: isAnnualLimitTyped,
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        context.read<AdminMainPageBloc>().add(
                                          AdminFinancialsUpdated(
                                            userEmail: _emailController.text
                                                .trim(),
                                            newAnnualLimit: double.parse(
                                              _annualLimitController.text
                                                  .trim(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              )
                            : SizedBox(),
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
