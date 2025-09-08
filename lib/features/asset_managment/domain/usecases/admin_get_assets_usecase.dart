import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/repo/admin_assetmng_repo.dart';

class AdminGetAssetsUsecase implements UsecaseWithStream<Either<String, List<Asset>>,String> {
  final AdminAssetmngRepo repo;

  AdminGetAssetsUsecase({required this.repo});

  @override
  Stream<Either<String, List<Asset>>> call(String param) {
    return repo.getAssetsList(param);
  }
}