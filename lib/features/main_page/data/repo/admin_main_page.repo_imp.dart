import 'package:dartz/dartz.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/main_page/data/datasources/admin_main_page_datasource.dart';
import 'package:ikproject/features/main_page/data/models/announcment_model.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class AdminMainPageRepoImp implements AdminMainPageRepo {
  final AdminMainPageDatasource _datasource;

  AdminMainPageRepoImp({required AdminMainPageDatasource datasource})
    : _datasource = datasource;
  @override
  Future<Either<String, UserEntity>> getUser(
    String adminEmail,
    String userEmail,
  ) async {
    final result = await _datasource.getUser(adminEmail, userEmail);

    return result.fold((failure) => Left(failure), (userModel) {
      final userEntity = UserEntity(
        fullName: userModel.fullName,
        email: userModel.email,
        role: userModel.role,
        financials: userModel.financials,
      );
      return Right(userEntity);
    });
  }

  @override
  Future<Either<String, Unit>> updateUserFinancials(
    String userEmail,
    double newAnnualLimit,
  ) async {
    return await _datasource.updateUserFinancials(userEmail, newAnnualLimit);
  }

  @override
  Future<Either<String, List<UserEntity>>> getAllUsers(
    String adminEmail,
  ) async {
    final result = await _datasource.getAllUsers(adminEmail);

    return result.fold((l) => Left(l), (list) {
      final usersEntity = list.map((e) {
        return UserEntity(
          fullName: e.fullName,
          email: e.email,
          role: e.role,
          financials: e.financials,
        );
      }).toList();

      return Right(usersEntity);
    });
  }

  @override
  Future<Either<String, List<SupportLineEntity>>> getAllSupportLineReqs(
    String adminEmail,
  ) async {
    final result = await _datasource.getAllSupportLineReqs(adminEmail);

    return result.fold((l) => Left(l), (list) {
      final reqEntity = list.map((e) {
        return SupportLineEntity(
          id: e.id,
          adminEmail: e.adminEmail,
          userEmail: e.userEmail,
          request: e.request,
        );
      }).toList();

      return Right(reqEntity);
    });
  }

  @override
  Future<Either<String, Unit>> createAnnouncment(
    AnnouncementEntity entity,
  ) async {
    final model = AnnouncmentModel(
      id: entity.id,
      adminEmail: entity.adminEmail,
      title: entity.title,
      details: entity.details,
      createdDate: entity.createdDate,
    );

    return await _datasource.createAnnouncment(model);
  }

  @override
  Stream<Either<String, List<AnnouncementEntity>>> getAllAnnouncments(
    String adminEmail,
  ) {
    final streamResult = _datasource.getAllAnnouncments(adminEmail);

    return streamResult.map((result) {
      return result.fold(
        (l) => Left(l),
        (list) => Right(
          list
              .map(
                (e) => AnnouncementEntity(
                  id: e.id,
                  adminEmail: e.adminEmail,
                  title: e.title,
                  details: e.details,
                  createdDate: e.createdDate,
                ),
              )
              .toList(),
        ),
      );
    });
  }
}
