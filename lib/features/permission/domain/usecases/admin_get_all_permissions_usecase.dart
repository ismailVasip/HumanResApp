import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/repo/admin_permission_repo.dart';

class AdminGetAllPermissionsUsecase implements UsecaseWithStream<Either<String,List<PermissionEntity>>,String>{
  final AdminPermissionRepo _repo;

  AdminGetAllPermissionsUsecase({required AdminPermissionRepo repo}) : _repo = repo;
  @override
  Stream<Either<String, List<PermissionEntity>>> call(String param) {
    return _repo.getPermissions(param);
  }
}