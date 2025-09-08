part of 'user_main_bloc.dart';

sealed class UserMainEvent {}

final class UserFetchAnnouncements extends UserMainEvent {
  final String adminEmail;

  UserFetchAnnouncements({required this.adminEmail});
}
