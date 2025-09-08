import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/presentation/admin_screens/bloc/admin_bonus_bloc.dart';
import 'package:intl/intl.dart';

class AdminBonusCard extends StatelessWidget {
  final AdvanceRequestEntity request;
  final bool showActions;
  final bool isLoading;

  const AdminBonusCard({
    super.key,
    required this.request,
    required this.showActions,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.none,
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Kim : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: request.userEmail,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (request.status == RequestStatus.autoApproved.name ||
                        request.status == RequestStatus.manualApproved.name ||
                        request.status == RequestStatus.rejected.name) ...[
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              request.status == RequestStatus.autoApproved.name
                              ? Colors.green
                              : request.status ==
                                    RequestStatus.manualApproved.name
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          request.status == RequestStatus.autoApproved.name
                              ? RequestStatus.autoApproved.displayName
                              : request.status ==
                                    RequestStatus.manualApproved.name
                              ? RequestStatus.manualApproved.displayName
                              : RequestStatus.rejected.displayName,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Avans Tutarı : ${request.amount.toInt().toString().splitMapJoin(RegExp(r'(?=(?!^)(?:\d{3})+$)'), onMatch: (m) => '.', onNonMatch: (n) => n)}₺',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Avans Talep Nedeni : ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: request.reason,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  DateFormat("dd.MM.yyyy").format(request.requestDate),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10,)
              ],
            ),
            if (showActions) ...[
              Positioned(
                right: -5,
                bottom: -5,
                child: Row(
                  children: [
                    _ActionButton(
                      color: Colors.red.shade400,
                      icon: Icons.clear,
                      onTap: () => _showActionDialog(
                        context,
                        false,
                        request.id,
                        request.userEmail,
                        request.amount,
                      ),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      color: Colors.green.shade400,
                      icon: Icons.done,
                      onTap: () => _showActionDialog(
                        context,
                        true,
                        request.id,
                        request.userEmail,
                        request.amount,
                      ),
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showActionDialog(
    BuildContext context,
    bool isAccepted,
    String requestId,
    String userEmail,
    double amount,
  ) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Emin misiniz?',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            isAccepted
                ? 'Avans talebi kabul edilsin mi?'
                : 'Avans talebi reddedilsin mi?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Hayır', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                context.read<AdminBonusBloc>().add(
                  AdminRequestStatusUpdate(
                    reqId: requestId,
                    userEmail: userEmail,
                    amount: amount,
                    newStatus: isAccepted
                        ? RequestStatus.manualApproved
                        : RequestStatus.rejected,
                  ),
                );
              },
              child: const Text('Evet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _ActionButton({
    required this.color,
    required this.icon,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      child: IconButton(
        onPressed: isLoading ? null : onTap,
        icon: Center(child: Icon(icon, color: Colors.white,size: 17,)),
      ),
    );
  }
}
