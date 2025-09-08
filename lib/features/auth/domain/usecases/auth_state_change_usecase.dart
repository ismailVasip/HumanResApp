import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikproject/core/usecase/usecase_with_stream.dart';
import 'package:ikproject/features/auth/domain/repo/auth_repo.dart';

class AuthStateChangeUsecase implements UsecaseWithStream<User?, NoParamsAuthState> {
  final AuthRepo _authRepo;
  AuthStateChangeUsecase({required AuthRepo authRepo}) : _authRepo = authRepo;

  @override
  Stream<User?> call(NoParamsAuthState param) {
    return _authRepo.authStateChanges;
  }
}

class NoParamsAuthState {}
