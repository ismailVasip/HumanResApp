part of 'create_admin_bloc.dart';

sealed class CreateAdminEvent {}

final class CreateUserWithAdminRoleEvent extends CreateAdminEvent{
  final String email;

  CreateUserWithAdminRoleEvent({required this.email});
}

final class MatchAdminAndUserEvent extends CreateAdminEvent{
  final String adminEmail;
  final String userEmail;

  MatchAdminAndUserEvent({required this.adminEmail, required this.userEmail});
}
