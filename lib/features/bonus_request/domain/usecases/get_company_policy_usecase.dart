import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/bonus_request/domain/entities/company_policy_entity.dart';
import 'package:ikproject/features/bonus_request/domain/repo/company_policy_repo.dart';

class GetCompanyPolicyUsecase
    implements Usecase<Either<String, CompanyPolicyEntity>, NoParams> {
  final CompanyPolicyRepo _repo;

  GetCompanyPolicyUsecase({required CompanyPolicyRepo repo}) : _repo = repo;
  @override
  Future<Either<String, CompanyPolicyEntity>> call(NoParams param) async {
    return await _repo.getCompanyPolicy();
  }
}

class NoParams {}
