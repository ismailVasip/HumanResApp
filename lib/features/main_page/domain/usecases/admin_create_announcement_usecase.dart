import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class AdminCreateAnnouncementUsecase
    implements Usecase<Either<String, Unit>, AnnouncementEntity> {
  final AdminMainPageRepo _repo;

  AdminCreateAnnouncementUsecase({required AdminMainPageRepo repo})
    : _repo = repo;
  @override
  Future<Either<String, Unit>> call(AnnouncementEntity param) async {
    return await _repo.createAnnouncment(param);
  }
}
