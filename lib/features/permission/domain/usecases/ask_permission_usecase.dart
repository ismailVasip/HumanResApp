import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/repo/user_permission_repo.dart';

class AskPermissionUsecase implements Usecase<Either<String,Unit>,PermissionEntity>{
  final UserPermissionRepo _repo;

  AskPermissionUsecase({required UserPermissionRepo repo}) : _repo = repo;
  @override
  Future<Either<String, Unit>> call(PermissionEntity param) async{
    return await _repo.askPermission(param);
  }
}
