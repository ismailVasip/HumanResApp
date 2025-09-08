import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/repo/admin_assetmng_repo.dart';

class AdminCancelAssignUsecase implements Usecase<Either<String,bool>,Asset> {
  final AdminAssetmngRepo repo;

  AdminCancelAssignUsecase({required this.repo});

  @override
  Future<Either<String, bool>> call(Asset param) async{
    return await repo.cancelAssignment(param);
  }
}