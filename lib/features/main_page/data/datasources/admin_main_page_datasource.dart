import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/features/asset_managment/data/model/support_line_model.dart';
import 'package:ikproject/features/main_page/data/models/announcment_model.dart';
import 'package:ikproject/features/main_page/data/models/user_model.dart';

abstract class AdminMainPageDatasource {
  Future<Either<String, UserModel>> getUser(
    String adminEmail,
    String userEmail,
  );
  Future<Either<String, Unit>> updateUserFinancials(
    String userEmail,
    double newAnnualLimit,
  );
  Future<Either<String, List<UserModel>>> getAllUsers(String adminEmail);
  Future<Either<String, List<SupportLineModel>>> getAllSupportLineReqs(
    String adminEmail,
  );
  Future<Either<String, Unit>> createAnnouncment(AnnouncmentModel model);
  Stream<Either<String, List<AnnouncmentModel>>> getAllAnnouncments(
    String adminEmail,
  );
}

class AdminMainPageDatasourceImp implements AdminMainPageDatasource {
  final _firestore = FirebaseFirestore.instance;
  @override
  Future<Either<String, UserModel>> getUser(
    String adminEmail,
    String userEmail,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('adminEmail', isEqualTo: adminEmail)
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Right(UserModel.fromFirestore(querySnapshot.docs.first));
      } else {
        return const Left('Bu e-postaya sahip bir kullanıcı bulunamadı.');
      }
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateUserFinancials(
    String userEmail,
    double newAnnualLimit,
  ) async {
    try {
      final qSnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (qSnapshot.docs.isEmpty) {
        return const Left('Güncellenecek kullanıcı bulunamadı.');
      }

      final userId = qSnapshot.docs.first.id;

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({
            "financials.annualLimit": newAnnualLimit,
            "financials.remainingLimit": newAnnualLimit,
          });

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<UserModel>>> getAllUsers(String adminEmail) async {
    try {
      final qSnap = await _firestore
          .collection(FirestoreCollections.users)
          .where('adminEmail', isEqualTo: adminEmail)
          .get();

      if (qSnap.docs.isEmpty) {
        return const Left('Bu yöneticiye atanmış çalışan bulunamadı!');
      }
      final List<UserModel> userList = qSnap.docs.map((doc) {
        return UserModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      }).toList();

      return Right(userList);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<SupportLineModel>>> getAllSupportLineReqs(
    String adminEmail,
  ) async {
    try {
      final qSnap = await _firestore
          .collection(FirestoreCollections.supportLine)
          .where('adminEmail', isEqualTo: adminEmail)
          .get();

      if (qSnap.docs.isEmpty) {
        return const Left('Bu yöneticiye ait talep bulunamadı!');
      }
      final List<SupportLineModel> reqList = qSnap.docs.map((doc) {
        return SupportLineModel.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
        );
      }).toList();

      return Right(reqList);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> createAnnouncment(AnnouncmentModel model) async {
    try {
      await _firestore
          .collection(FirestoreCollections.announcements)
          .add(model.toMap());

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<AnnouncmentModel>>> getAllAnnouncments(
    String adminEmail,
  ) {
    try {
      return _firestore
          .collection(FirestoreCollections.announcements)
          .where('adminEmail', isEqualTo: adminEmail)
          .orderBy('createdDate', descending: true)
          .snapshots()
          .map((qSnap) {
            final list = qSnap.docs.map((doc) {
              return AnnouncmentModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              );
            }).toList();

            return Right(list);
          });
    } on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken hata oluştu!'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }
}
