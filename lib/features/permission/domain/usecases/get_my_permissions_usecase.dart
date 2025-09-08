import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/repo/user_permission_repo.dart';

class GetMyPermissionsUsecase implements UsecaseWithStream<Either<String,List<PermissionEntity>>,String>{
  final UserPermissionRepo _repo;

  GetMyPermissionsUsecase({required UserPermissionRepo repo}) : _repo = repo;
  @override
  Stream<Either<String, List<PermissionEntity>>> call(String param) {
    return _repo.getMyPermissions(param);
  }
}