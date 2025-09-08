import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/permission/data/model/permission_model.dart';

abstract class AdminPermissionDatasource {
  Stream<Either<String, List<PermissionModel>>> getPermissions(String adminEmail);
  Future<Either<String,Unit>>  evaluateRequest(bool isAccepted,String requestId);
}

class AdminPermissionDatasourceImp implements AdminPermissionDatasource{
  final _firestore = FirebaseFirestore.instance;
  @override
  Stream<Either<String, List<PermissionModel>>> getPermissions(String adminEmail) {
    try{
      return _firestore
      .collection(FirestoreCollections.permissions)
      .where('adminEmail',isEqualTo: adminEmail)
      .orderBy('createdDate',descending: true)
      .snapshots()
      .map((qSnapshot){
        final List<PermissionModel> list = qSnapshot.docs
          .map((doc){
            return PermissionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>
            );
          }).toList();

          return Right(list);
      });

    }on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken bir hata oluştu.'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }
  
  @override
  Future<Either<String, Unit>> evaluateRequest(bool isAccepted,String requestId) async{
    try{
      final String newStatus = isAccepted ? 'accepted' : 'rejected';
      
      await _firestore.collection(FirestoreCollections.permissions).doc(requestId).update({'status':newStatus});

      return Right(unit);


    }on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }
}