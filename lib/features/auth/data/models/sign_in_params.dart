import 'package:ikproject/features/auth/domain/entities/sign_in_entity.dart';

class SignInRequestParams extends SignInEntity{
  SignInRequestParams({required super.email, required super.password});
}
