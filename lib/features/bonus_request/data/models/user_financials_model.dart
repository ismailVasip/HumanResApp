import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';

class UserFinancialsModel extends UserFinancialsEntity {
  UserFinancialsModel({
    required super.userEmail,
    required super.annualLimit,
    required super.remainingLimit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userEmail': userEmail,
      'annualLimit': annualLimit,
      'remainingLimit': remainingLimit,
    };
  }

  factory UserFinancialsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> docSnap,String userEmail
  ) {
    final data = docSnap.data();
    
    final financialsData = data?['financials'] as Map<String, dynamic>? ?? {};

    return UserFinancialsModel(
      userEmail: userEmail,
      annualLimit: (financialsData['annualLimit'] ?? 0.0).toDouble(),
      remainingLimit: (financialsData['remainingLimit'] ?? 0.0).toDouble(),
    );
  }
}
