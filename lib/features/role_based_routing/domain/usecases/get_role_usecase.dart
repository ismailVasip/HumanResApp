import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/role_based_routing/domain/repo/role_repo.dart';
import 'package:ikproject/service_locator.dart';

class GetRoleUsecase implements Usecase<Either<String,(String,String?)>,NoParams> {
  @override
  Future<Either<String,(String,String?)>> call(NoParams param) async{
    return await serviceLocator<GetRoleRepo>().getCurrentUserRole();
  }
}

class NoParams{}