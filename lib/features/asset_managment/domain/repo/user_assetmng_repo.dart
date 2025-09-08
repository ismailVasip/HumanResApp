import 'package:dartz/dartz.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';

abstract interface class UserAssetmngRepo {
  Stream<Either<String, List<Asset>>> getAssetsList(String toWho);
  Future<Either<String, Unit>> sendReqToSupportLine(SupportLineEntity entity);
}