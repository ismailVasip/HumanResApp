import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/advance_request_repo.dart';

class GetAdminAdvanceReqUsecase
    implements
        UsecaseWithStream<Either<String, List<AdvanceRequestEntity>>, String> {
  final AdvanceRequestRepo _repo;

  GetAdminAdvanceReqUsecase({required AdvanceRequestRepo repo}) : _repo = repo;
  @override
  Stream<Either<String, List<AdvanceRequestEntity>>> call(String param) {
    return _repo.getAdminAdvanceRequests(param);
  }
}
