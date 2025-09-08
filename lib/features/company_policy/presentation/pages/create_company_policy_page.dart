import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/company_policy/presentation/bloc/create_policy_bloc.dart';
import 'package:ikproject/features/company_policy/presentation/widgets/button.dart';
import 'package:ikproject/features/company_policy/presentation/widgets/list_text_field.dart';
import 'package:ikproject/features/company_policy/presentation/widgets/text_field.dart';
import 'package:ikproject/service_locator.dart';

class CreateCompanyPolicyPage extends StatefulWidget {
  const CreateCompanyPolicyPage({super.key});

  @override
  State<CreateCompanyPolicyPage> createState() =>
      _CreateCompanyPolicyPageState();
}

class _CreateCompanyPolicyPageState extends State<CreateCompanyPolicyPage> {
  final TextEditingController _maxAmountController = TextEditingController();
  final TextEditingController _reasonsController = TextEditingController();
  final TextEditingController _maxInstallmentsController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<String> _validReasons = [];

  @override
  void dispose() {
    _maxAmountController.dispose();
    _maxInstallmentsController.dispose();
    _reasonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Şirket Politikaları', isBackButtonActive: true),
      body: BlocProvider(
        create: (context) => serviceLocator<CreatePolicyBloc>(),
        child: BlocConsumer<CreatePolicyBloc, CreatePolicyState>(
          listener: (context, state) {
            if (state is CreatePolicyFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
            }
            if (state is CreatedCompanyPolicy) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Şirket Politikası Oluşturuldu.'),
                    backgroundColor: Colors.green,
                  ),
                );
              _key.currentState?.reset();
              _maxAmountController.clear();
              _maxInstallmentsController.clear();
              _validReasons.clear();
            }
          },
          builder: (context, state) {
            bool isLoading = state is CreatePolicyLoading;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Şirket Politikası Oluştur',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //autoApprovalMaxAmount field
                    MyTextFormField(
                      controller: _maxAmountController,
                      label: 'Otomatik Onay Limiti',
                    ),

                    //validReasons field
                    StringListInputPage(
                      textController: _reasonsController,
                      onListChanged: (value) => setState(() {
                        _validReasons = value;
                      }),
                    ),

                    //maxInstallments field
                    MyTextFormField(
                      controller: _maxInstallmentsController,
                      label: 'Maksimum Taksit',
                    ),

                    //save button
                    SaveButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_key.currentState!.validate()) {
                                context.read<CreatePolicyBloc>().add(
                                  CompanyPolicyCreated(
                                    autoApprovalMaxAmount:
                                        double.tryParse(
                                          _maxAmountController.text.trim(),
                                        ) ??
                                        0,
                                    validReasons: _validReasons,
                                    maxInstallments:
                                        int.tryParse(
                                          _maxInstallmentsController.text
                                              .trim(),
                                        ) ??
                                        0,
                                  ),
                                );
                              }
                            },
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
