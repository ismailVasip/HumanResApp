import 'package:dartz/dartz.dart';

abstract interface class CreateAdminRepo {
  Future<Either<String, bool>> createUserWithRoleAdmin(String email);
  Future<Either<String, bool>> matchAdminAndUser(
    String adminEmail,
    String userEmail,
  );
}
