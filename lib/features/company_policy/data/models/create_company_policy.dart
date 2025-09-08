import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/company_policy/domain/entities/create_company_policy.dart';

class CreateCompanyPolicyModel extends CreateCompanyPolicyEntity {
  CreateCompanyPolicyModel({
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

  factory CreateCompanyPolicyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return CreateCompanyPolicyModel(
      autoApprovalMaxAmount: (data['autoApprovalMaxAmount'] ?? 0).toDouble(),
      validReasons: List<String>.from(data['validReasons'] ?? []),
      maxInstallments: data['maxInstallments'] ?? 0,
    );
  }
}
