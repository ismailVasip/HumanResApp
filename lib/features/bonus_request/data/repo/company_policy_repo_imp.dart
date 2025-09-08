import 'package:dartz/dartz.dart';
import 'package:ikproject/features/bonus_request/data/datasources/company_policy_datasource.dart';
import 'package:ikproject/features/bonus_request/domain/entities/company_policy_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/company_policy_repo.dart';

class CompanyPolicyRepoImp implements CompanyPolicyRepo {
  final CompanyPolicyDatasource _datasource;

  CompanyPolicyRepoImp({required CompanyPolicyDatasource datasource})
    : _datasource = datasource;
  @override
  Future<Either<String, CompanyPolicyEntity>> getCompanyPolicy() async {
    final result = await _datasource.getCompanyPolicy();

    return result.fold((l) => Left(l), (r) => Right(r as CompanyPolicyEntity));
  }
}
