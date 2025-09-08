import 'package:flutter/material.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/presentation/admin_screens/widgets/admin_bonus_card.dart';

class AdminBonusReqList extends StatelessWidget {
  final int position;
  final List<AdvanceRequestEntity> list;
  final bool isLoading;

  const AdminBonusReqList({
    super.key,
    required this.position,
    required this.list,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    List<AdvanceRequestEntity> filtered;
    if (position == 0) {
      filtered = list
          .where((e) => e.status == RequestStatus.pending.name)
          .toList();
    } else if (position == 1) {
      filtered = list
          .where(
            (e) =>
                (e.status == RequestStatus.autoApproved.name) ||
                (e.status == RequestStatus.manualApproved.name),
          )
          .toList();
    } else {
      filtered = list
          .where((e) => e.status == RequestStatus.rejected.name)
          .toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          position == 0
              ? "Bekleyen avans talebi yok."
              : position == 1
              ? "Henüz kabul edilen avans talebi yok."
              : "Henüz reddedilen avans talebi yok.",
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => AdminBonusCard(
        request: filtered[index],
        showActions: position == 0,
        isLoading: isLoading,
      ),
    );
  }
}
