import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/auth/domain/repo/auth_repo.dart';
import 'package:ikproject/service_locator.dart';

class SignUpUseCase implements Usecase<Either,SignUpParams>{
  @override
  Future<Either<String,User>> call(SignUpParams param) async{
    return serviceLocator<AuthRepo>().signUp(
      param.fullName,
      param.email,
      param.password
    );
  }
}

class SignUpParams{
  final String fullName;
  final String email;
  final String password;

  SignUpParams({required this.fullName, required this.email, required this.password});
}