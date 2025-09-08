import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/presentation/user-screens/bloc/permission_block.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_cause_input_field.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_permission_date_picker_section.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_permission_type_selector.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_submit_permission_button.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class AskForPermissionPage extends StatefulWidget {
  const AskForPermissionPage({super.key});

  @override
  State<AskForPermissionPage> createState() => _AskForPermissionPageState();
}

class _AskForPermissionPageState extends State<AskForPermissionPage> {
  final TextEditingController _causeController = TextEditingController();

  String _selectedType = 'casual';

  String _startDate = '';
  String _endDate = '';
  String userEmail = '';

  bool get _isDateRangeSelected => _startDate.isNotEmpty && _endDate.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      userEmail = authState.user.email!;
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        if (args.value.startDate != null) {
          _startDate = DateFormat('dd.MM.yyyy').format(args.value.startDate!);
        }
        if (args.value.endDate != null) {
          _endDate = DateFormat('dd.MM.yyyy').format(args.value.endDate!);
        } else if (args.value.startDate != null) {
          _endDate = DateFormat('dd.MM.yyyy').format(args.value.startDate!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
      body: SafeArea(
        child: BlocProvider(
          create: (context) => serviceLocator<PermissionBloc>(),
          child: BlocConsumer<PermissionBloc, PermissionState>(
            listener: (context, state) {
              if (state is PermissionFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
              if (state is PermissionActionSuccess) {
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
              bool isLoading = state is PermissionLoading;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Yeni İzin Talebi',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      //form
                      Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 2),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          spacing: 16,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //option picker
                            UserPermissionTypeSelector(
                              selectedType: _selectedType,
                              onTypeSelected: (option) {
                                setState(() {
                                  _selectedType = option;
                                });
                              },
                            ),

                            //cause input field
                            UserCauseInputField(controller: _causeController),

                            //date picker
                            UserPermissionDatePickerSection(
                              startDate: _startDate,
                              endDate: _endDate,
                              onSelectionChanged: (value) =>
                                  _onSelectionChanged(value),
                            ),
                          ],
                        ),
                      ),
                      //submit button
                      UserSubmitPermissionButton(
                        onPressed: !_isDateRangeSelected
                            ? null
                            : () {
                                final now = DateTime.now();
                                final today = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                );
                                final selectedStartDate = DateFormat(
                                  "dd.MM.yyyy",
                                ).parse(_startDate);

                                if (!selectedStartDate.isBefore(today)) {
                                  context.read<PermissionBloc>().add(
                                    AskPermissionRequested(
                                      entity: PermissionEntity(
                                        id: Uuid().v4(),
                                        type: _selectedType,
                                        cause: _causeController.text.trim(),
                                        startDate: DateFormat(
                                          "dd.MM.yyyy",
                                        ).parse(_startDate),
                                        endDate: DateFormat(
                                          "dd.MM.yyyy",
                                        ).parse(_endDate),
                                        createdDate: DateTime.now(),
                                        status: 'waiting',
                                        userEmail: userEmail,
                                        adminEmail: '',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text('Geçmiş tarihler seçilemez!'),
                                        backgroundColor: Colors.red,
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
      ),
    );
  }
}
