import 'package:dartz/dartz.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';

abstract interface class AdminPermissionRepo {
  Stream<Either<String, List<PermissionEntity>>> getPermissions(String adminEmail);
  Future<Either<String,Unit>> evaluateRequest(bool isAccepted,String requestId);
}