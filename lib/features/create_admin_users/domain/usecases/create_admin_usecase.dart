import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/create_admin_users/domain/repo/create_admin_repo.dart';

class CreateAdminUsecase implements Usecase<Either<String,bool>,CreateAdminParams>{
  final CreateAdminRepo _repo;

  CreateAdminUsecase({required CreateAdminRepo repo}) : _repo = repo;
  @override
  Future<Either<String, bool>> call(CreateAdminParams param) async{
    return await _repo.createUserWithRoleAdmin(param.email);
  }
}

class CreateAdminParams{
  final String email;

  CreateAdminParams({required this.email});
}
