import 'package:flutter/material.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/presentation/admin-screens/widgets/a_permission_card.dart';


class AdminPermissionListView extends StatelessWidget {
  final int position;
  final List<PermissionEntity> permissions;
  final bool isLoading;

  const AdminPermissionListView({
    super.key,
    required this.position,
    required this.permissions,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    List<PermissionEntity> filtered;
    if (position == 0) {
      filtered = permissions.where((e) => e.status == 'waiting').toList();
    } else if (position == 1) {
      filtered = permissions.where((e) => e.status == 'accepted').toList();
    } else {
      filtered = permissions.where((e) => e.status == 'rejected').toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          position == 0
              ? "Bekleyen izin talebi yok."
              : position == 1
                  ? "Henüz kabul edilen izin talebi yok."
                  : "Henüz reddedilen izin talebi yok.",
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => AdminPermissionCard(
        permission: filtered[index],
        showActions: position == 0,
        isLoading:isLoading
      ),
    );
  }
}
