import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/common/constants/firestore_constants.dart';

class GetAdminEmail {
  
  GetAdminEmail._privateConstructor();
  static final GetAdminEmail instance = GetAdminEmail._privateConstructor();

  final _firestore = FirebaseFirestore.instance;

  
  Future<String?> getAdminEmailForUser(String userEmail) async {
    try {
  
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.assignments)
          .where('userEmail', isEqualTo: userEmail)
          .limit(1) 
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return data['adminEmail'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
