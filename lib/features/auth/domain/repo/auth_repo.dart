import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRepo {
  Future<Either<String,User>> signIn(String email,String password);
  Future<Either<String,User>> signUp(String fullName,String email,String password);
  Future<Either<String,bool>> checkUserExistsByEmail(String email);
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<void> signOut();
}