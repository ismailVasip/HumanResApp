import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/permission/data/model/permission_model.dart';

abstract class UserPermissionDatasource {
  Future<Either<String, Unit>> askPermission(PermissionModel model);
  Stream<Either<String, List<PermissionModel>>> getMyPermissions(
    String userEmail,
  );
}

class UserPermissionDatasourceImp implements UserPermissionDatasource {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, Unit>> askPermission(PermissionModel model) async {
    try {
      QuerySnapshot<Map<String, dynamic>> query = await _firestore
          .collection(FirestoreCollections.assignments)
          .where('userEmail', isEqualTo: model.userEmail)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return Left('Yönetici atanmadan izin talep edilemez!');
      }

      final adminEmail = query.docs.first.data()['adminEmail'] as String;

      final data = model.toMap();
      data['adminEmail'] = adminEmail;

      await _firestore.collection(FirestoreCollections.permissions).add(data);

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<PermissionModel>>> getMyPermissions(
    String userEmail,
  ) {
    try {
      return _firestore
          .collection(FirestoreCollections.permissions)
          .where('userEmail', isEqualTo: userEmail)
          .orderBy('createdDate', descending: true)
          .snapshots()
          .map((qSnapshot) {
            final List<PermissionModel> list = qSnapshot.docs.map((doc) {
              return PermissionModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              );
            }).toList();

            return Right(list);
          });
    } on FirebaseException catch (e) {
      return Stream.value(
        Left(e.message ?? 'Veri dinlenirken bir hata oluştu.'),
      );
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }
}
