import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';

class AdvanceRequestModel extends AdvanceRequestEntity {
  AdvanceRequestModel({
    required super.id,
    required super.userEmail,
    required super.adminEmail,
    required super.amount,
    required super.reason,
    required super.status,
    required super.requestDate,
    required super.repaymentPlan,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userEmail': userEmail,
      'adminEmail': adminEmail,
      'amount': amount,
      'reason': reason,
      'status': status,
      'requestDate': requestDate,
      'repaymentPlan': repaymentPlan,
    };
  }

  factory AdvanceRequestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return AdvanceRequestModel(
      id: snapshot.id,
      userEmail: data?['userEmail'],
      adminEmail: data?['adminEmail'],
      amount: (data?['amount'] as num).toDouble(),
      reason: data?['reason'],
      status: data?['status'],
      requestDate: (data?['requestDate'] as Timestamp).toDate(),
      repaymentPlan: data?['repaymentPlan'] is Map
          ? Map<String, dynamic>.from(data?['repaymentPlan'])
          : null,
    );
  }
}
