import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/company_policy/domain/entities/create_company_policy.dart';
import 'package:ikproject/features/company_policy/domain/repo/create_company_policy_repo.dart';

class CreateCompanyPolicyUsecase
    implements Usecase<Either<String, Unit>, PolicyParams> {
  final CreateCompanyPolicyRepo _repo;

  CreateCompanyPolicyUsecase({required CreateCompanyPolicyRepo repo})
    : _repo = repo;
  @override
  Future<Either<String, Unit>> call(PolicyParams param) async {
    final policyEntity = CreateCompanyPolicyEntity(
      autoApprovalMaxAmount: param.autoApprovalMaxAmount,
      validReasons: param.validReasons,
      maxInstallments: param.maxInstallments,
    );
    return await _repo.createCompanyPolicy(policyEntity);
  }
}

class PolicyParams {
  final double autoApprovalMaxAmount;
  final List<String> validReasons;
  final int maxInstallments;

  PolicyParams({
    required this.autoApprovalMaxAmount,
    required this.validReasons,
    required this.maxInstallments,
  });
}
