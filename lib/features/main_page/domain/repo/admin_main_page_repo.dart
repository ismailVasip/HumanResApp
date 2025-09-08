import 'package:dartz/dartz.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';

abstract interface class AdminMainPageRepo {
  Future<Either<String, UserEntity>> getUser(
    String adminEmail,
    String userEmail,
  );
  Future<Either<String, Unit>> updateUserFinancials(
    String userEmail,
    double newAnnualLimit,
  );
  Future<Either<String, List<UserEntity>>> getAllUsers(String adminEmail);
  Future<Either<String, List<SupportLineEntity>>> getAllSupportLineReqs(
    String adminEmail,
  );
  Future<Either<String, Unit>> createAnnouncment(AnnouncementEntity entity);
  Stream<Either<String, List<AnnouncementEntity>>> getAllAnnouncments(
    String adminEmail,
  );
}
