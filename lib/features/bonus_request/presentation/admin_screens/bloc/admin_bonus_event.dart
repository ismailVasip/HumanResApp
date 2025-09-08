part of 'admin_bonus_bloc.dart';

sealed class AdminBonusEvent {}

final class AdminRequestStatusUpdate extends AdminBonusEvent {
  final String reqId;
  final String userEmail;
  final double amount;
  final RequestStatus newStatus;

  AdminRequestStatusUpdate({
    required this.reqId,
    required this.userEmail,
    required this.amount,
    required this.newStatus,
  });
}

final class AdminPendingRequestsFetch extends AdminBonusEvent {
  final String adminEmail;

  AdminPendingRequestsFetch({required this.adminEmail});
}
