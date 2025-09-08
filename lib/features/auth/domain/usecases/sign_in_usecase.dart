import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/auth/domain/repo/auth_repo.dart';
import 'package:ikproject/service_locator.dart';

class SignInUseCase implements Usecase<Either,SignInParams>{
  @override
  Future<Either<String,User>> call(SignInParams param) async{
    return serviceLocator<AuthRepo>().signIn(
      param.email,
      param.password
    );
  }
}

class SignInParams{
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}