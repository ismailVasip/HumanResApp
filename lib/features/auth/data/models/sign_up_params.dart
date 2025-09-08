import 'package:ikproject/features/auth/domain/entities/sign_up_entity.dart';

class SignUpRequestParams extends SignUpEntity{
  SignUpRequestParams({
    required super.fullName,
    required super.email,
    required super.password,
  });
}