import 'package:dartz/dartz.dart';
import 'package:ikproject/features/company_policy/domain/entities/create_company_policy.dart';

abstract interface class CreateCompanyPolicyRepo {
  Future<Either<String,Unit>> createCompanyPolicy(
    CreateCompanyPolicyEntity entity
  );
}