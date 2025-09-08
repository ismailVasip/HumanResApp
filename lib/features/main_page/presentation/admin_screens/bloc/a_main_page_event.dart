part of 'a_main_page_bloc.dart';

sealed class AMainPageEvent {}

final class AdminUserLoaded extends AMainPageEvent {
  final String adminEmail;
  final String userEmail;

  AdminUserLoaded({required this.adminEmail, required this.userEmail});
}

final class AdminFinancialsUpdated extends AMainPageEvent {
  final String userEmail;
  final double newAnnualLimit;

  AdminFinancialsUpdated({
    required this.userEmail,
    required this.newAnnualLimit,
  });
}

final class AdminFetchAllUsers extends AMainPageEvent {
  final String adminEmail;

  AdminFetchAllUsers({required this.adminEmail});
}

final class AdminFetchAllSupportLineReq extends AMainPageEvent {
  final String adminEmail;

  AdminFetchAllSupportLineReq({required this.adminEmail});
}

final class AdminCreateAnnouncementReq extends AMainPageEvent {
  final AnnouncementEntity entity;

  AdminCreateAnnouncementReq({required this.entity});
}

final class FetchAllAnnouncements extends AMainPageEvent {
  final String adminEmail;

  FetchAllAnnouncements({required this.adminEmail});
}
