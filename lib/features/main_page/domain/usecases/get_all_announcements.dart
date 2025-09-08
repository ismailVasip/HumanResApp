import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class GetAllAnnouncementsUsecase
    implements
        UsecaseWithStream<Either<String, List<AnnouncementEntity>>, String> {
  final AdminMainPageRepo _repo;

  GetAllAnnouncementsUsecase({required AdminMainPageRepo repo}) : _repo = repo;
  @override
  Stream<Either<String, List<AnnouncementEntity>>> call(String param) {
    return _repo.getAllAnnouncments(param);
  }
}
