import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class AdminGetSupportLineReqUsecase
    implements Usecase<Either<String, List<SupportLineEntity>>, String> {
  final AdminMainPageRepo _repo;

  AdminGetSupportLineReqUsecase({required AdminMainPageRepo repo})
    : _repo = repo;
  @override
  Future<Either<String, List<SupportLineEntity>>> call(String param) async {
    return await _repo.getAllSupportLineReqs(param);
  }
}
