// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/singleton/get_admin_email.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/bloc/user_bonus_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:uuid/uuid.dart';

class SummaryAndConfirmWidget extends StatefulWidget {
  String? selectedReason;
  double? selectedAmount;
  double remainingLimit;
  int maxInstallments;
  String? userEmail;
  bool isAutoApproved;
  SummaryAndConfirmWidget({
    required this.selectedReason,
    required this.selectedAmount,
    required this.remainingLimit,
    required this.maxInstallments,
    required this.userEmail,
    required this.isAutoApproved,
    super.key,
  });

  @override
  State<SummaryAndConfirmWidget> createState() =>
      _SummaryAndConfirmWidgetState();
}

class _SummaryAndConfirmWidgetState extends State<SummaryAndConfirmWidget> {
  String? adminEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserBonusBloc>(),
      child: BlocConsumer<UserBonusBloc, UserBonusState>(
        listener: (context, state) {
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
          if (state is UserAdvanceReqCreated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('İşlem Başarılı'),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 30,
              children: [
                Text(
                  'Özet ve Onay',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blueAccent.shade100,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Seçilen Neden: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      widget.selectedReason ??
                                      'Bir neden seçilmedi.',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            spacing: 6,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.green,
                                size: 24,
                              ),
                              Expanded(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Tutar: ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.selectedAmount == null
                                            ? 'Avans tutarı seçiniz.'
                                            : '${widget.selectedAmount}₺',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            spacing: 6,
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Colors.orange,
                                size: 24,
                              ),
                              Expanded(
                                child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Geri Ödeme: ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.selectedAmount == null
                                            ? 'Avans tutarı seçilmedi.'
                                            : "${widget.maxInstallments} x ${(widget.selectedAmount! / widget.maxInstallments).toInt()}₺",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.orange.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: -10,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "ÖNEMLİ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black45,
                      elevation: 6,
                    ),
                    onPressed: () async {
                      String status = '';
                      Map<String, dynamic> repaymentPlan = {};
                      if (widget.userEmail != null) {
                        adminEmail = await GetAdminEmail.instance
                            .getAdminEmailForUser(widget.userEmail!);
                      } else {
                        adminEmail = null;
                      }
                      if (widget.isAutoApproved) {
                        status = RequestStatus.autoApproved.name;
                      } else {
                        status = RequestStatus.pending.name;
                      }
                      if (widget.selectedAmount != null &&
                          widget.selectedReason != null &&
                          widget.userEmail != null &&
                          adminEmail != null) {
                        repaymentPlan = {
                          'installments': widget.maxInstallments,
                          'monthly_deduction':
                              widget.selectedAmount! / widget.maxInstallments,
                        };

                        context.read<UserBonusBloc>().add(
                          UserCreateAdvanceReq(
                            entity: AdvanceRequestEntity(
                              id: Uuid().v4(),
                              userEmail: widget.userEmail!,
                              adminEmail: adminEmail!,
                              amount: widget.selectedAmount!,
                              reason: widget.selectedReason!,
                              status: status,
                              requestDate: DateTime.now(),
                              repaymentPlan: repaymentPlan,
                            ),
                            newRemainingLimit:
                                widget.remainingLimit -
                                (widget.selectedAmount ?? 0.0),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Onayla ve Gönder",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
