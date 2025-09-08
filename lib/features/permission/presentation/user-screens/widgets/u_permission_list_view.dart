import 'package:flutter/material.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/presentation/user-screens/widgets/u_permission_card.dart';

class UserPermissionListView extends StatelessWidget {
  final int position;
  final List<PermissionEntity> permissions;
  const UserPermissionListView({
    required this.position,
    required this.permissions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<PermissionEntity> filtered = permissions;
    if (position == 0) {
      filtered = permissions;
    } else if (position == 1) {
      filtered = permissions
          .where((e) => e.type.toLowerCase() == 'casual')
          .toList();
    } else if (position == 2) {
      filtered = permissions
          .where((e) => e.type.toLowerCase() == 'sick')
          .toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          position == 0
              ? "Henüz izin talebiniz yok."
              : position == 1
              ? "Henüz genel sebepli izin talebiniz yok."
              : "Henüz hastalık sebepli izin talebiniz yok.",
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        return UserPermissionCard(permission: filtered[index]);
      },
    );
  }
}
