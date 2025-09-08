import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/bonus_request/data/models/company_poilcy_model.dart';

abstract class CompanyPolicyDatasource {
  Future<Either<String,CompanyPoilcyModel>> getCompanyPolicy();
}

class CompanyPolicyDatasourceImp implements CompanyPolicyDatasource{
  final _firestore = FirebaseFirestore.instance;
  @override
  Future<Either<String, CompanyPoilcyModel>> getCompanyPolicy() async{
    try{
      final docSnap = await _firestore.collection(FirestoreCollections.companyPolicies).doc('mainPolicy').get();

      if(docSnap.exists && docSnap.data() != null){
        return Right(CompanyPoilcyModel.fromFirestore(docSnap));
      } else {
        return Left('Şirket Politikası mevcut değil.');
      }

    } on FirebaseException catch(e){
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch(e){
      return Left(e.toString());
    }
  }
}