import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseRoleDatasource {
  Future<Either<String, String?>> getCurrentUserRole();
}

class FirebaseRoleDatasourceImp implements FirebaseRoleDatasource {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  @override
  Future<Either<String, String?>> getCurrentUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left('User does not exist!');

      final doc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
      return Right(doc.data()?['role'][0]);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
