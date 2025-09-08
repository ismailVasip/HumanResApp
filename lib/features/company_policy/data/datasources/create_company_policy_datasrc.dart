import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/company_policy/data/models/create_company_policy.dart';

abstract class CreateCompanyPolicyDatasrc {
  Future<Either<String, Unit>> createCompanyPolicy(
    CreateCompanyPolicyModel policyModel,
  );
}

class CreateCompanyPolicyDatasrcImp implements CreateCompanyPolicyDatasrc {
  final _firestore = FirebaseFirestore.instance;
  @override
  Future<Either<String, Unit>> createCompanyPolicy(
    CreateCompanyPolicyModel policyModel,
  ) async {
    try {
      Map<String, dynamic> data = policyModel.toMap();
      await _firestore
          .collection(FirestoreCollections.companyPolicies)
          .doc("mainPolicy")
          .set(data);

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
