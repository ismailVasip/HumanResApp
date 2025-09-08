part of 'user_main_bloc.dart';

sealed class UserMainState {}

final class UserMainInitial extends UserMainState {}

final class UserMainLoading extends UserMainState {}

final class UserMainFailure extends UserMainState {
  final String error;

  UserMainFailure({required this.error});
}

final class UserAnnouncementsFetched extends UserMainState {
  final List<AnnouncementEntity> list;

  UserAnnouncementsFetched({required this.list});
}
