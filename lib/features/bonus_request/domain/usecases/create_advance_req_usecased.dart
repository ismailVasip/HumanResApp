import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/advance_request_repo.dart';

class CreateAdvanceReqUsecase
    implements Usecase<Either<String, Unit>, CreateAdvanceReqParams> {
  final AdvanceRequestRepo _repo;

  CreateAdvanceReqUsecase({required AdvanceRequestRepo repo}) : _repo = repo;
  @override
  Future<Either<String, Unit>> call(CreateAdvanceReqParams param) async {
    return await _repo.createAdvanceRequest(
      param.entity,
      param.newRemainingLimit,
    );
  }
}

class CreateAdvanceReqParams {
  final AdvanceRequestEntity entity;
  final double newRemainingLimit;

  CreateAdvanceReqParams({
    required this.entity,
    required this.newRemainingLimit,
  });
}
