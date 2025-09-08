import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/asset_managment/data/model/asset_dto.dart';
import 'package:ikproject/features/asset_managment/data/model/support_line_model.dart';

abstract class UserAssetmngDatasrc {
  Stream<Either<String, List<AssetDto>>> getAssetsList(String toWho);
  Future<Either<String,Unit>> sendReqToSupportLine(SupportLineModel model);
}

class UserAssetmngDatasrcImp implements UserAssetmngDatasrc{
  final _firestore = FirebaseFirestore.instance;
  
  @override
  Stream<Either<String, List<AssetDto>>> getAssetsList(String toWho) {
    try{
      return _firestore
      .collection(FirestoreCollections.assetManagement)
      .where('toWho',isEqualTo: toWho)
      .orderBy('assignDate',descending: true)
      .snapshots()
      .map((qSnapshot){
        final List<AssetDto> assetList = qSnapshot.docs
          .map((doc){
            return AssetDto.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>
            );
          }).toList();

          return Right(assetList);
      });

    } on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken bir hata oluştu.'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }
  
  @override
  Future<Either<String, Unit>> sendReqToSupportLine(SupportLineModel model) async{
    try{
      await _firestore.collection(FirestoreCollections.supportLine).add(model.toMap());

      return Right(unit);

    }on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }
}