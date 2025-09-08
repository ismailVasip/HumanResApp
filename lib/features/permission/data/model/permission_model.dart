import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';

class PermissionModel extends PermissionEntity {
  PermissionModel({
    required super.id,
    required super.type,
    required super.cause,
    required super.startDate,
    required super.endDate,
    required super.createdDate,
    required super.status,
    required super.userEmail,
    required super.adminEmail
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'cause': cause,
      'startDate': startDate,
      'endDate': endDate,
      'createdDate': createdDate,
      'status': status,
      'userEmail': userEmail,
      'adminEmail':adminEmail
    };
  }

  factory PermissionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return PermissionModel(
      id: doc.id,
      type: data['type'] ?? '',
      cause: data['cause'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      status: data['status'] ?? '',
      userEmail: data['userEmail'] ?? '',
      adminEmail: data['adminEmail'] ?? ''
    );
  }
}
