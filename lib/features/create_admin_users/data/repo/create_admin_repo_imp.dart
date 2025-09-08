import 'package:dartz/dartz.dart';
import 'package:ikproject/features/create_admin_users/data/datasources/create_admin_datasrc.dart';
import 'package:ikproject/features/create_admin_users/domain/repo/create_admin_repo.dart';

class CreateAdminRepoImp implements CreateAdminRepo{
  final CreateAdminDatasrc _datasrc;

  CreateAdminRepoImp({required CreateAdminDatasrc datasrc}) : _datasrc = datasrc;
  @override
  Future<Either<String, bool>> createUserWithRoleAdmin(String email) async{
    try{
      return await _datasrc.createAdminRole(email);
    } catch(e){
      return Left(e.toString());
    }
  }
  
  @override
  Future<Either<String, bool>> matchAdminAndUser(String adminEmail, String userEmail) async{
    try{
      return await _datasrc.matchAdminAndUser(adminEmail, userEmail);

    }catch(e){
      return Left(e.toString());
    }
  }
}