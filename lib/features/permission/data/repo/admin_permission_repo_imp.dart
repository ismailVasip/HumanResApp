import 'package:dartz/dartz.dart';
import 'package:ikproject/features/permission/data/datasources/admin_permission_datasource.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/repo/admin_permission_repo.dart';

class AdminPermissionRepoImp implements AdminPermissionRepo {
  final AdminPermissionDatasource _datasource;

  AdminPermissionRepoImp({required AdminPermissionDatasource datasource})
    : _datasource = datasource;
  @override
  Stream<Either<String, List<PermissionEntity>>> getPermissions(
    String adminEmail,
  ) {
    final stream = _datasource.getPermissions(adminEmail);

    return stream.map((result) {
      return result.fold(
        (failure) {
          return Left(failure);
        },
        (list) {
          final List<PermissionEntity> permissionList = list.map((dto) {
            return PermissionEntity(
              id: dto.id,
              type: dto.type,
              cause: dto.cause,
              startDate: dto.startDate,
              endDate: dto.endDate,
              createdDate: dto.createdDate,
              status: dto.status,
              userEmail: dto.userEmail,
              adminEmail: dto.adminEmail,
            );
          }).toList();

          return Right(permissionList);
        },
      );
    });
  }
  
  @override
  Future<Either<String, Unit>> evaluateRequest(bool isAccepted, String requestId) async{
    
    return await _datasource.evaluateRequest(isAccepted, requestId);
  }
}
