import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/data/models/advance_request_model.dart';

abstract class AdvanceRequestDatasource {
  Future<Either<String, Unit>> createAdvanceRequest(
    AdvanceRequestModel reqModel,
    double newRemainingLimit,
  );
  Stream<Either<String, List<AdvanceRequestModel>>> getUserAdvanceRequests(
    String userEmail,
  );
  Stream<Either<String, List<AdvanceRequestModel>>> getAdminAdvanceRequests(
    String adminEmail,
  );
  Future<Either<String, Unit>> updateRequestStatus(
    String reqId,
    String userEmail,
    double amount,
    RequestStatus newStatus,
  );
}

class AdvanceRequestDatasourceImp implements AdvanceRequestDatasource {
  final _firestore = FirebaseFirestore.instance;
  @override
  Future<Either<String, Unit>> createAdvanceRequest(
    AdvanceRequestModel reqModel,
    double newRemainingLimit,
  ) async {
    try {
      final userQuery = await _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: reqModel.userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return const Left('Avans talebi oluşturulacak kullanıcı bulunamadı.');
      }
      final userDocRef = userQuery.docs.first.reference;

      final newAdvanceRequestRef = _firestore
          .collection(FirestoreCollections.advanceRequest)
          .doc();

      await _firestore.runTransaction((transaction) async {
        transaction.set(newAdvanceRequestRef, reqModel.toMap());

        if (reqModel.status == 'autoApproved') {
          transaction.update(userDocRef, {
            "financials.remainingLimit": newRemainingLimit,
          });
        }
      });

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either<String, List<AdvanceRequestModel>>> getAdminAdvanceRequests(
    String adminEmail,
  ) {
    try {
      return _firestore
          .collection(FirestoreCollections.advanceRequest)
          .where('adminEmail', isEqualTo: adminEmail)
          .orderBy('requestDate', descending: true)
          .snapshots()
          .map((qSnap) {
            final reqList = qSnap.docs.map((doc) {
              return AdvanceRequestModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              );
            }).toList();
            return Right(reqList);
          });
    } on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken hata oluştu!'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }

  @override
  Stream<Either<String, List<AdvanceRequestModel>>> getUserAdvanceRequests(
    String userEmail,
  ) {
    try {
      return _firestore
          .collection(FirestoreCollections.advanceRequest)
          .where('userEmail', isEqualTo: userEmail)
          .orderBy('requestDate', descending: true)
          .snapshots()
          .map((qSnap) {
            final reqList = qSnap.docs.map((doc) {
              return AdvanceRequestModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              );
            }).toList();

            return Right(reqList);
          });
    } on FirebaseException catch (e) {
      return Stream.value(Left(e.message ?? 'Veri dinlenirken hata oluştu!'));
    } catch (e) {
      return Stream.value(Left(e.toString()));
    }
  }

  @override
  Future<Either<String, Unit>> updateRequestStatus(
    String reqId,
    String userEmail,
    double amount,
    RequestStatus newStatus,
  ) async {
    try {
      final userQuery = await _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return const Left('Kullanıcı bulunamadı.');
      }
      final userDocRef = userQuery.docs.first.reference;

      double? remainingLimit;

      if (userQuery.docs.isNotEmpty) {
        final data = userQuery.docs.first.data();

        if (data.containsKey('financials') && data['financials'] is Map) {
          final financialsData = data['financials'] as Map<String, dynamic>;

          if (financialsData.containsKey('remainingLimit') &&
              financialsData['remainingLimit'] is num) {
            remainingLimit = (financialsData['remainingLimit'] as num).toDouble();
          }
        }
      }

      final reqRef = _firestore
          .collection(FirestoreCollections.advanceRequest)
          .doc(reqId);

      await _firestore.runTransaction((transaction) async {
        //statusu güncelle
        transaction.update(reqRef, {'status': newStatus.name});

        //eğer onaylandıysa user->financials güncelle
        if (newStatus.name == 'manualApproved' && remainingLimit != null) {
          transaction.update(userDocRef, {
            "financials.remainingLimit": remainingLimit - amount,
          });
        }
      });

      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
