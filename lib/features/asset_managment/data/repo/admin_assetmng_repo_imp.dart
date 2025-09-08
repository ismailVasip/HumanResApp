import 'package:dartz/dartz.dart';
import 'package:ikproject/features/asset_managment/data/datasources/admin_assetmng_datasrc.dart';
import 'package:ikproject/features/asset_managment/data/model/asset_dto.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/repo/admin_assetmng_repo.dart';
import 'package:ikproject/service_locator.dart';

class AdminAssetmngRepoImp implements AdminAssetmngRepo {
  final AdminAssetmngDatasrc remoteDataSource;

  AdminAssetmngRepoImp({required this.remoteDataSource});

  @override
  Future<Either<String, bool>> asignAsset(Asset asset) async {
    try {
      var assetDto = AssetDto(
        id: asset.id,
        byWho: asset.byWho,
        toWho: asset.toWho,
        brand: asset.brand,
        model: asset.model,
        serialNumber: asset.serialNumber,
        assignDate: asset.assignDate,
      );

      return await serviceLocator<AdminAssetmngDatasrc>().asignAsset(assetDto);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> cancelAssignment(Asset asset) async {
    try {
      var assetDto = AssetDto(
        id: asset.id,
        byWho: asset.byWho,
        toWho: asset.toWho,
        brand: asset.brand,
        model: asset.model,
        serialNumber: asset.serialNumber,
        assignDate: asset.assignDate,
      );

      return await serviceLocator<AdminAssetmngDatasrc>().cancelAssignment(
        assetDto,
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<Asset>>> getAssetsList(String byWho) {
    final dtoStream = remoteDataSource.getAssetsList(byWho);

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
}
