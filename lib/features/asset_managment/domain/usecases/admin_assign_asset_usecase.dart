import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/repo/admin_assetmng_repo.dart';
import 'package:ikproject/features/auth/domain/repo/auth_repo.dart';

class AdminAssignassetUsecase implements Usecase<Either<String, bool>, Asset> {
  final AdminAssetmngRepo repo;
  final AuthRepo authRepo;

  AdminAssignassetUsecase({required this.repo,required this.authRepo});
  
  @override
  Future<Either<String, bool>> call(Asset param) async{
    final userCheckResult = await authRepo.checkUserExistsByEmail(param.toWho);

    return userCheckResult.fold(
      (failure) {
        return Left(failure);
      },

      (userExists) {
        if (userExists) {
          return repo.asignAsset(param);
        } else {
          return Left('Bu e-postaya sahip bir kullanıcı bulunamadı.');
        }
      },
    );
  }
  

}