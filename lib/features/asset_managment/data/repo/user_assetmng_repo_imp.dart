import 'package:dartz/dartz.dart';
import 'package:ikproject/features/asset_managment/data/datasources/user_assetmng_datasrc.dart';
import 'package:ikproject/features/asset_managment/data/model/support_line_model.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/asset_managment/domain/repo/user_assetmng_repo.dart';

class UserAssetmngRepoImp implements UserAssetmngRepo {
  final UserAssetmngDatasrc _datasrc;

  UserAssetmngRepoImp({required UserAssetmngDatasrc datasrc})
    : _datasrc = datasrc;
  @override
  Stream<Either<String, List<Asset>>> getAssetsList(String toWho) {
    final dtoStream = _datasrc.getAssetsList(toWho);

    return dtoStream.map((result) {
      return result.fold(
        (failure) {
          return Left(failure);
        },
        (assetDtoList) {
          final List<Asset> assetList = assetDtoList.map((dto) {
            return Asset(
              id: dto.id,
              byWho: dto.byWho,
              toWho: dto.toWho,
              brand: dto.brand,
              model: dto.model,
              serialNumber: dto.serialNumber,
              assignDate: dto.assignDate,
            );
          }).toList();

          return Right(assetList);
        },
      );
    });
  }

  @override
  Future<Either<String, Unit>> sendReqToSupportLine(
    SupportLineEntity entity,
  ) async {
    return await _datasrc.sendReqToSupportLine(
      SupportLineModel(
        id: entity.id,
        adminEmail: entity.adminEmail,
        userEmail: entity.userEmail,
        request: entity.request,
      ),
    );
  }
}
