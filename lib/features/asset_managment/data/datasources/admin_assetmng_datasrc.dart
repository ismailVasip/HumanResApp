import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/asset_managment/data/model/asset_dto.dart';

abstract class AdminAssetmngDatasrc {
  Future<Either<String, bool>> asignAsset(AssetDto assetDto);
  Stream<Either<String, List<AssetDto>>> getAssetsList(String byWho);
  Future<Either<String, bool>> cancelAssignment(AssetDto assetDto);
}

class AdminAssetManagmentImp implements AdminAssetmngDatasrc {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, bool>> asignAsset(AssetDto assetDto) async {
    try {
      await _firestore
          .collection(FirestoreCollections.assetManagement)
          .doc(assetDto.id)
          .set(assetDto.toMap());

      return Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> cancelAssignment(AssetDto assetDto) async {
    try {
      await _firestore
          .doc('${FirestoreCollections.assetManagement}/${assetDto.id}')
          .delete();

      return Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<AssetDto>>> getAssetsList(String byWho) {
    try {
      return _firestore
          .collection(FirestoreCollections.assetManagement)
          .where('byWho', isEqualTo: byWho)
          .orderBy('assignDate', descending: true)
          .snapshots() 
          .map((querySnapshot) {
            final List<AssetDto> assetList = querySnapshot.docs
                .map(
                  (doc) => AssetDto.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ),
                )
                .toList();
            return Right<String, List<AssetDto>>(assetList);
          });
    } on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken bir hata oluştu.'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }
}
