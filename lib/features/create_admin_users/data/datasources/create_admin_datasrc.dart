import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';

abstract class CreateAdminDatasrc {
  Future<Either<String, bool>> createAdminRole(String email);
  Future<Either<String, bool>> matchAdminAndUser(
    String adminEmail,
    String userEmail,
  );
}

class CreateAdminDatasrcImp implements CreateAdminDatasrc {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, bool>> createAdminRole(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      final userDoc = querySnapshot.docs.first;

      final data = userDoc.data();
      List<dynamic> roles = List.from(data['role'] ?? []);

      if (roles.isNotEmpty) {
        roles[0] = 'admin';
      }

      await userDoc.reference.update({'role': roles});

      return Right(true);
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> matchAdminAndUser(
    String adminEmail,
    String userEmail,
  ) async {
    try {
      //tekrarı önleme
      final existing = await _firestore
          .collection(FirestoreCollections.assignments)
          .where('adminEmail', isEqualTo: adminEmail)
          .where('userEmail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return Left('Bu eşleşme zaten mevcut.');
      }

      await _firestore.collection(FirestoreCollections.assignments).add({
        'adminEmail': adminEmail,
        'userEmail': userEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      await _firestore.collection(FirestoreCollections.users).doc().set({
        'adminEmail': adminEmail,
      }, SetOptions(merge: true));

      final userQuery = await _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userId = userQuery.docs.first.id;

        await _firestore.collection(FirestoreCollections.users).doc(userId).set(
          {'adminEmail': adminEmail},
          SetOptions(merge: true),
        );

        return Right(true);
      } else {
        return Left('Atama sırasında hata oluştu!');
      }
    } on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu!');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
