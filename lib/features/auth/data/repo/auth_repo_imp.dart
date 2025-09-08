import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikproject/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:ikproject/features/auth/data/models/sign_in_params.dart';
import 'package:ikproject/features/auth/data/models/sign_up_params.dart';
import 'package:ikproject/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  final FirebaseAuthDatasource _datasource;

  AuthRepoImp({required FirebaseAuthDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<String, User>> signIn(
    String email,
    String password,
  ) async {
    SignInRequestParams model = SignInRequestParams(
      email: email,
      password: password,
    );
    Either<String, User> result = await _datasource.signIn(model);

    return result.fold(
      (l) {
        return Left(l);
      },
      (r) {
        return Right(r);
      },
    );
  }

  @override
  Future<Either<String, User>> signUp(
    String fullName,
    String email,
    String password,
  ) async {
    SignUpRequestParams model = SignUpRequestParams(
      fullName: fullName,
      email: email,
      password: password,
    );
    Either<String, User> result = await _datasource.signUp(model);

    return result.fold(
      (l) {
        return Left(l);
      },
      (r) {
        return Right(r);
      },
    );
  }

  @override
  Future<Either<String, bool>> checkUserExistsByEmail(String email) async {
    try {
      return await _datasource.checkUserExistsByEmail(email);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<User?> get authStateChanges => _datasource.authStateChanges;

  @override
  User? get currentUser => _datasource.currentUser;

  @override
  Future<void> signOut() => _datasource.signOut();
}
