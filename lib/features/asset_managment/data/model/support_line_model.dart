import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';

class SupportLineModel extends SupportLineEntity {
  SupportLineModel({
    required super.id,
    required super.adminEmail,
    required super.userEmail,
    required super.request,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'adminEmail': adminEmail,
      'userEmail': userEmail,
      'request': request,
    };
  }

  factory SupportLineModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return SupportLineModel(
      id: data['id'] ?? '',
      adminEmail: data['adminEmail'] ?? '',
      userEmail: data['userEmail'] ?? '',
      request: data['request'] ?? '',
    );
  }
}
