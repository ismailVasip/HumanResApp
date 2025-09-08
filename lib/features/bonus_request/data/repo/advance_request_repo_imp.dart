import 'package:dartz/dartz.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/data/datasources/advance_request_datasource.dart';
import 'package:ikproject/features/bonus_request/data/models/advance_request_model.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/advance_request_repo.dart';

class AdvanceRequestRepoImp implements AdvanceRequestRepo {
  final AdvanceRequestDatasource _datasource;

  AdvanceRequestRepoImp({required AdvanceRequestDatasource datasource})
    : _datasource = datasource;
  @override
  Future<Either<String, Unit>> createAdvanceRequest(
    AdvanceRequestEntity reqEntity,
    double newRemainingLimit,
  ) async {
    final reqModel = AdvanceRequestModel(
      id: reqEntity.id,
      userEmail: reqEntity.userEmail,
      adminEmail: reqEntity.adminEmail,
      amount: reqEntity.amount,
      reason: reqEntity.reason,
      status: reqEntity.status,
      requestDate: reqEntity.requestDate,
      repaymentPlan: reqEntity.repaymentPlan,
    );
    return await _datasource.createAdvanceRequest(reqModel, newRemainingLimit);
  }

  @override
  Stream<Either<String, List<AdvanceRequestEntity>>> getAdminAdvanceRequests(
    String adminEmail,
  ) {
    return _datasource.getAdminAdvanceRequests(adminEmail).map((result) {
      return result.fold(
        (l) => Left(l),
        (r) => Right(r.map((e) => e as AdvanceRequestEntity).toList()),
      );
    });
  }

  @override
  Stream<Either<String, List<AdvanceRequestEntity>>> getUserAdvanceRequests(
    String userEmail,
  ) {
    return _datasource.getUserAdvanceRequests(userEmail).map((result) {
      return result.fold(
        (l) => Left(l),
        (r) => Right(r.map((e) => e as AdvanceRequestEntity).toList()),
      );
    });
  }

  @override
  Future<Either<String, Unit>> updateRequestStatus(
    String reqId,
    String userEmail,
    double amount,
    RequestStatus newStatus,
  ) async {
    return await _datasource.updateRequestStatus(
      reqId,
      userEmail,
      amount,
      newStatus,
    );
  }
}
