import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/bonus_request/domain/entities/company_policy_entity.dart';

class CompanyPoilcyModel extends CompanyPolicyEntity {
  CompanyPoilcyModel({
    required super.autoApprovalMaxAmount,
    required super.validReasons,
    required super.maxInstallments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'autoApprovalMaxAmount': autoApprovalMaxAmount,
      'validReasons': validReasons,
      'maxInstallments': maxInstallments,
    };
  }

  factory CompanyPoilcyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return CompanyPoilcyModel(
      autoApprovalMaxAmount: (data?['autoApprovalMaxAmount'] as num?)?.toDouble(),
      validReasons: data?['validReasons'] is Iterable
          ? List<String>.from(data?['validReasons'])
          : null,
      maxInstallments: data?['maxInstallments'] as int?,
    );
  }
}
