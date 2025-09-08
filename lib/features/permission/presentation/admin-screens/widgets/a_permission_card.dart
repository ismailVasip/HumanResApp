import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/presentation/admin-screens/bloc/admin_permission_bloc.dart';
import 'package:intl/intl.dart';

class AdminPermissionCard extends StatelessWidget {
  final PermissionEntity permission;
  final bool showActions;
  final bool isLoading;

  const AdminPermissionCard({
    super.key,
    required this.permission,
    required this.showActions,
    required this.isLoading
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Kim: ${permission.userEmail}",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    if (permission.status == 'accepted' ||
                        permission.status == 'rejected') ...[
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: permission.status == 'accepted'
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          permission.status == 'accepted'
                              ? 'Kabul edildi'
                              : 'Reddedildi',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormat("dd.MM.yyyy").format(permission.startDate)} - ${DateFormat("dd.MM.yyyy").format(permission.endDate)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${permission.type.substring(0, 1).toUpperCase()}${permission.type.substring(1)}',
                  style: TextStyle(
                    color: permission.type == 'sick'
                        ? Colors.blue
                        : Colors.orange,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  permission.cause.isEmpty
                      ? "Açıklama: Yapılmadı"
                      : "Açıklama: ${permission.cause}",
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 8),
              Positioned(
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    _ActionButton(
                      color: Colors.red.shade400,
                      icon: Icons.clear,
                      onTap: () =>
                          _showActionDialog(context, false, permission.id),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      color: Colors.green.shade400,
                      icon: Icons.done,
                      onTap: () =>
                          _showActionDialog(context, true, permission.id),
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
                ? 'İzin talebi kabul edilsin mi?'
                : 'İzin talebi reddedilsin mi?',
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
                context.read<AdminPermissionBloc>().add(
                  RequestEvaluated(
                    isAccepted: isAccepted,
                    requestId: requestId,
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
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      child: IconButton(
        onPressed: isLoading ? null : onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
