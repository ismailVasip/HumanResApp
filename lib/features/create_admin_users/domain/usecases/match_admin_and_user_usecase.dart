import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/create_admin_users/domain/repo/create_admin_repo.dart';

class MatchAdminAndUserUsecase implements Usecase<Either<String,bool>,MathcingParams>{
  final CreateAdminRepo _repo;

  MatchAdminAndUserUsecase({required CreateAdminRepo repo}) : _repo = repo;
  @override
  Future<Either<String, bool>> call(MathcingParams param) async{
    return await _repo.matchAdminAndUser(param.adminEmail, param.userEmail);
  }
}

class MathcingParams{
  final String adminEmail;
  final String userEmail;

  MathcingParams({required this.adminEmail, required this.userEmail});
}