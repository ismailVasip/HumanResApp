import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/bonus_request/data/models/user_financials_model.dart';

abstract class UserFinancialsDatasource {
  Stream<Either<String, UserFinancialsModel>> getUserFinancials(
    String userEmail,
  );
}

class UserFinancialsDatasourceImp extends UserFinancialsDatasource {
  final _firestore = FirebaseFirestore.instance;
  @override
  Stream<Either<String, UserFinancialsModel>> getUserFinancials(
    String userEmail,
  ) {
    try {
      return _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: userEmail)
          .snapshots()
          .map((qSnap) {
            if (qSnap.docs.isNotEmpty) {
              final doc = qSnap.docs.first;
              final userFinancials = UserFinancialsModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
                userEmail,
              );
              return Right(userFinancials);
            } else {
              return const Left('Bu e-postaya sahip bir kullanıcı bulunamadı.');
            }
          });
    } on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken hata oluştu!'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }
}
