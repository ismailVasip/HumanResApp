import 'package:dartz/dartz.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/bonus_request/domain/repo/advance_request_repo.dart';

class UpdateReqStatusUsecase
    implements Usecase<Either<String, Unit>, UpdateReqStatusParams> {
  final AdvanceRequestRepo _repo;

  UpdateReqStatusUsecase({required AdvanceRequestRepo repo}) : _repo = repo;

  @override
  Future<Either<String, Unit>> call(UpdateReqStatusParams param) async {
    return await _repo.updateRequestStatus(
      param.reqId,
      param.userEmail,
      param.amount,
      param.newStatus,
    );
  }
}

class UpdateReqStatusParams {
  final String reqId;
  final String userEmail;
  final double amount;
  final RequestStatus newStatus;

  UpdateReqStatusParams({required this.reqId, required this.userEmail, required this.amount, required this.newStatus});
}
