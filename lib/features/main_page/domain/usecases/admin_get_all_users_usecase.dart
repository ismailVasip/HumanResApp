import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class AdminGetAllUsersUsecase
    implements Usecase<Either<String, List<UserEntity>>, String> {
  final AdminMainPageRepo _repo;

  AdminGetAllUsersUsecase({required AdminMainPageRepo repo}) : _repo = repo;
  @override
  Future<Either<String, List<UserEntity>>> call(String param) async {
    return await _repo.getAllUsers(param);
  }
}
