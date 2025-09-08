part of 'a_main_page_bloc.dart';

sealed class AMainPageState {}

final class AdminMainPageInitial extends AMainPageState {}

final class AdminMainPageSearchUserLoading extends AMainPageState {}

final class AdminMainPageSupportLineLoading extends AMainPageState {}

final class AdminMainPageCreateAnnouncementLoading extends AMainPageState {}

final class AdminMainPageFetchAllAnnouncementsLoading extends AMainPageState {}

final class AdminMainPageUpdateFinancialLoading extends AMainPageState {}

final class AdminMainPageGetUsersLoading extends AMainPageState {}

final class AdminMainPageFailure extends AMainPageState {
  final String error;

  AdminMainPageFailure({required this.error});
}

final class AdminMainPageActionSuccess extends AMainPageState {
  final String message;

  AdminMainPageActionSuccess({required this.message});
}

final class AdminMainPageUserFetched extends AMainPageState {
  final UserEntity user;

  AdminMainPageUserFetched({required this.user});
}

final class AdminAllUsersFetched extends AMainPageState {
  final List<UserEntity> list;

  AdminAllUsersFetched({required this.list});
}

final class AdminAllSupportLineReqFetched extends AMainPageState {
  final List<SupportLineEntity> entity;

  AdminAllSupportLineReqFetched({required this.entity});
}

final class AdminAnnouncementCreated extends AMainPageState {
  final String message;

  AdminAnnouncementCreated({required this.message});
}

final class AdminAllAnnouncementsFetched extends AMainPageState {
  final List<AnnouncementEntity> list;

  AdminAllAnnouncementsFetched({required this.list});
}
