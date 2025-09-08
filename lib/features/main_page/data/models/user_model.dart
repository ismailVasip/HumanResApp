import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.fullName,
    required super.email,
    required super.role,
    required super.financials,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserModel(
      fullName: data?['fullName'],
      email: data?['email'],
      role: data?['role'] is Iterable ? List.from(data?['role']) : null,
      financials: data?['financials'] is Map
          ? Map<String, dynamic>.from(data?['financials'])
          : null,
    );
  }
}
