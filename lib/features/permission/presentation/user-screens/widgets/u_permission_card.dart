import 'package:flutter/material.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:intl/intl.dart';

class UserPermissionCard extends StatelessWidget {
  final PermissionEntity permission;
  const UserPermissionCard({required this.permission, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          margin: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${permission.endDate.difference(permission.startDate).inDays} gün izin.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: permission.status == 'waiting'
                          ? Colors.orange.shade100
                          : permission.status == 'accepted'
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      permission.status == 'waiting'
                          ? 'Bekliyor'
                          : permission.status == 'accepted'
                          ? 'Kabul Edildi'
                          : 'Reddedildi',
                      style: TextStyle(
                        fontSize: 12,
                        color: permission.status == 'waiting'
                            ? Colors.orange.shade900
                            : permission.status == 'accepted'
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                  ),
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
                permission.type.toLowerCase() == 'sick' ? 'Hastalık' : 'Genel',
                style: TextStyle(
                  color: permission.type.toLowerCase() == 'sick'
                      ? Colors.blue.shade700
                      : Colors.orange.shade700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                permission.cause.isEmpty
                    ? 'Açıklama : Yapılmadı'
                    : 'Açıklama : ${permission.cause}',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
