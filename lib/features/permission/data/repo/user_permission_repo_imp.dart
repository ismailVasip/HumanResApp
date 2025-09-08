import 'package:dartz/dartz.dart';
import 'package:ikproject/features/permission/data/datasources/user_permission_datasource.dart';
import 'package:ikproject/features/permission/data/model/permission_model.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/repo/user_permission_repo.dart';

class UserPermissionRepoImp implements UserPermissionRepo {
  final UserPermissionDatasource _datasource;

  UserPermissionRepoImp({required UserPermissionDatasource datasource})
    : _datasource = datasource;
  @override
  Future<Either<String, Unit>> askPermission(PermissionEntity model) async {
    try {
      final permissionModel = PermissionModel(
        id: model.id,
        type: model.type,
        cause: model.cause,
        startDate: model.startDate,
        endDate: model.endDate,
        createdDate: model.createdDate,
        status: model.status,
        userEmail: model.userEmail,
        adminEmail: model.adminEmail,
      );
      return await _datasource.askPermission(permissionModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<PermissionEntity>>> getMyPermissions(
    String userEmail,
  ) {
    final dtoStream = _datasource.getMyPermissions(userEmail);

    return dtoStream.map((result) {
      return result.fold((l) => Left(l), (list) {
        final returnList = list.map((item) {
          return PermissionEntity(
            id: item.id,
            type: item.type,
            cause: item.cause,
            startDate: item.startDate,
            endDate: item.endDate,
            createdDate: item.createdDate,
            status: item.status,
            userEmail: userEmail,
            adminEmail: item.adminEmail,
          );
        }).toList();

        return Right(returnList);
      });
    });
  }
}
