import 'package:dartz/dartz.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';

abstract interface class AdminAssetmngRepo {
  Future<Either<String, bool>> asignAsset(Asset asset);
  Stream<Either<String, List<Asset>>> getAssetsList(String byWho);
  Future<Either<String, bool>> cancelAssignment(Asset asset);
}
