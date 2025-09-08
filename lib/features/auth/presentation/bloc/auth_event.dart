part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  AuthSignUp(this.fullName,  this.email,  this.password);

}

final class AuthSignIn extends AuthEvent{
  final String email;
  final String password;

  AuthSignIn( this.email,  this.password);
}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged(this.user);
}


class AuthLogoutRequested extends AuthEvent {}
