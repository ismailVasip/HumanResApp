import 'package:dartz/dartz.dart';
import 'package:ikproject/features/company_policy/data/datasources/create_company_policy_datasrc.dart';
import 'package:ikproject/features/company_policy/data/models/create_company_policy.dart';
import 'package:ikproject/features/company_policy/domain/entities/create_company_policy.dart';
import 'package:ikproject/features/company_policy/domain/repo/create_company_policy_repo.dart';

class CreateCompanyPolicyRepoImp implements CreateCompanyPolicyRepo {
  final CreateCompanyPolicyDatasrc _datasrc;

  CreateCompanyPolicyRepoImp({required CreateCompanyPolicyDatasrc datasrc})
    : _datasrc = datasrc;
  @override
  Future<Either<String, Unit>> createCompanyPolicy(
    CreateCompanyPolicyEntity entity,
  ) async {
    final policyModel = CreateCompanyPolicyModel(
      autoApprovalMaxAmount: entity.autoApprovalMaxAmount,
      validReasons: entity.validReasons,
      maxInstallments: entity.maxInstallments,
    );

    return await _datasrc.createCompanyPolicy(policyModel);
  }
}
