import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikproject/features/auth/data/models/sign_in_params.dart';
import 'package:ikproject/features/auth/data/models/sign_up_params.dart';

abstract class FirebaseAuthDatasource {
  Future<Either<String,User>> signUp(SignUpRequestParams signUpReq);
  Future<Either<String,User>> signIn(SignInRequestParams signInparams);
  Future<Either<String,bool>> checkUserExistsByEmail(String email);
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<void> signOut();
}

class FirebaseAuthDatasourceImp implements FirebaseAuthDatasource{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String,User>> signUp(SignUpRequestParams signUpReq) async{
    try{
      var userCredential =  await _auth.createUserWithEmailAndPassword(email: signUpReq.email, password: signUpReq.password);

      final userId = userCredential.user!.uid;
      await _firestore.collection("users").doc(userId).set({
        "fullName":signUpReq.fullName,
        "email":signUpReq.email,
        "role": ["user"],
        "createdAt": FieldValue.serverTimestamp(),
      });

      return Right(userCredential.user!);

    }catch(e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String,User>> signIn(SignInRequestParams signInparams) async{
    try{
      var userCredential =  await _auth.signInWithEmailAndPassword(email: signInparams.email, password: signInparams.password);

      return Right(userCredential.user!);

    }catch(e){
      return Left(e.toString());
    }
  }

  
  
  @override
  Future<Either<String, bool>> checkUserExistsByEmail(String email) async{
    try{
      final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return Right(querySnapshot.docs.isNotEmpty);

    }on FirebaseException catch (e) {
      return Left(e.message ?? 'Bir Firebase hatası oluştu.');
    } catch (e) {
      return Left(e.toString());
    }
  }
  
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  @override
  User? get currentUser => _auth.currentUser;
  
  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

}