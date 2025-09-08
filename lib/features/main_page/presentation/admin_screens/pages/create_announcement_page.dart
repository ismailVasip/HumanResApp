import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/bloc/a_main_page_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:uuid/uuid.dart';

class CreateAnnouncementPage extends StatefulWidget {
  final String adminEmail;
  const CreateAnnouncementPage({required this.adminEmail, super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Duyuru Yap', isBackButtonActive: true),
      body: BlocProvider(
        create: (context) => serviceLocator<AdminMainPageBloc>(),
        child: SafeArea(
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
              }
              if (state is AdminAnnouncementCreated) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                _key.currentState!.reset();
                _subjectController.clear();
                _detailsController.clear();
              }
            },
            builder: (context, state) {
              bool isLoading = state is AdminMainPageCreateAnnouncementLoading;

              return Form(
                key: _key,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          'Duyuru Oluştur',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Konu',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(hintText: 'Konu'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Bu alan bış bırakılamaz!';
                            }
                            return null;
                          },
                        ),
                        Text(
                          'Açıklama',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: _detailsController,
                          maxLines: 3,
                          decoration: InputDecoration(hintText: 'Açıklama'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Bu alan bış bırakılamaz!';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_key.currentState!.validate()) {
                                      context.read<AdminMainPageBloc>().add(
                                        AdminCreateAnnouncementReq(
                                          entity: AnnouncementEntity(
                                            id: Uuid().v4(),
                                            adminEmail: widget.adminEmail,
                                            title: _subjectController.text
                                                .trim(),
                                            details: _detailsController.text
                                                .trim(),
                                            createdDate: DateTime.now(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 1,
                                      trackGap: 1,
                                    ),
                                )
                                : const Text(
                                    "YAYINLA",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      ),
    );
  }
}
