import 'package:dartz/dartz.dart';
import 'package:ikproject/features/bonus_request/data/datasources/user_financials_datasource.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/user_financials_repo.dart';

class UserFinancialsRepoImp implements UserFinancialsRepo {
  final UserFinancialsDatasource _datasource;

  UserFinancialsRepoImp({required UserFinancialsDatasource datasource})
    : _datasource = datasource;
  @override
  Stream<Either<String, UserFinancialsEntity>> getUserFinancials(
    String userEmail,
  ) {
    return _datasource.getUserFinancials(userEmail).map((result) {
      return result.fold(
        (l) => Left(l),
        (r) => Right(r as UserFinancialsEntity),
      );
    });
  }
}
