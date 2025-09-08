import 'package:dartz/dartz.dart';
import 'package:ikproject/features/bonus_request/domain/entities/company_policy_entity.dart';

abstract interface class CompanyPolicyRepo {
  Future<Either<String,CompanyPolicyEntity>> getCompanyPolicy();
}