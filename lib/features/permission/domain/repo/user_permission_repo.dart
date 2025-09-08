import 'package:dartz/dartz.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';

abstract interface class UserPermissionRepo {
  Future<Either<String, Unit>> askPermission(PermissionEntity model);
  Stream<Either<String, List<PermissionEntity>>> getMyPermissions(
    String userEmail,
  );
}