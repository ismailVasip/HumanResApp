import 'package:dartz/dartz.dart';
import 'package:ikproject/core/data/datasources/get_user_info.dart';
import 'package:ikproject/features/role_based_routing/domain/repo/role_repo.dart';
import 'package:ikproject/service_locator.dart';

class GetRoleRepoImp implements GetRoleRepo{
  @override
  Future<Either<String, (String,String?)>> getCurrentUserRole() async{
    Either<String,(String,String?)> result = await serviceLocator<FirebaseRoleDatasource>().getCurrentUserRole();

    return result.fold(
      (l) {
        return Left(l);
      },
      (r) {
        return Right(r);
      }
    );
  }
}