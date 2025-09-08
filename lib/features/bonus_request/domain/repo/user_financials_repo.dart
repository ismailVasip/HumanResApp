import 'package:dartz/dartz.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';

abstract interface class UserFinancialsRepo {
  Stream<Either<String, UserFinancialsEntity>> getUserFinancials(
    String userEmail,
  );
}
