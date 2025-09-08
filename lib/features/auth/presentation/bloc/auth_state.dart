part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState{}

final class AuthLoading extends AuthState{}

final class AuthFailure extends AuthState{
  final String error;

  AuthFailure(this.error);
}

final class AuthSuccess extends AuthState{
  final User user;

  AuthSuccess(this.user);
}

final class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

final class Unauthenticated extends AuthState {}
