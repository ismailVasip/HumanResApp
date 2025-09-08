import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/user_financials_repo.dart';

class GetUserFinancialsUsecase
    implements UsecaseWithStream<Either<String, UserFinancialsEntity>, String> {
  final UserFinancialsRepo _repo;

  GetUserFinancialsUsecase({required UserFinancialsRepo repo}) : _repo = repo;
  @override
  Stream<Either<String, UserFinancialsEntity>> call(String param) {
    return _repo.getUserFinancials(param);
  }
}
