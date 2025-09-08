import 'package:dartz/dartz.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';

abstract interface class AdvanceRequestRepo {
  Future<Either<String, Unit>> createAdvanceRequest(
    AdvanceRequestEntity reqEntity,
    double newRemainingLimit,
  );
  Stream<Either<String, List<AdvanceRequestEntity>>> getUserAdvanceRequests(
    String userEmail,
  );
  Stream<Either<String, List<AdvanceRequestEntity>>> getAdminAdvanceRequests(
    String adminEmail,
  );
  Future<Either<String, Unit>> updateRequestStatus(
    String reqId,
    String userEmail,
    double amount,
    RequestStatus newStatus,
  );
}
