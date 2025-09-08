import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class AdminGetUserUsecase implements Usecase<Either<String,UserEntity>,GetUserParams>{
  final AdminMainPageRepo _repo;

  AdminGetUserUsecase({required AdminMainPageRepo repo}) : _repo = repo;
  @override
  Future<Either<String, UserEntity>> call(GetUserParams param) async{
    return await _repo.getUser(param.adminEmail,param.userEmail);
  }
}

class GetUserParams {
  final String adminEmail;
  final String userEmail;

  GetUserParams({required this.adminEmail, required this.userEmail});
}