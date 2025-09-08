part of 'admin_permission_bloc.dart';

sealed class AdminPermissionEvent{}

final class AllPermissionsFetched extends AdminPermissionEvent{
  final String adminEmail;

  AllPermissionsFetched({required this.adminEmail});
}

final class RequestEvaluated extends AdminPermissionEvent{
  final bool isAccepted;
  final String requestId;

  RequestEvaluated({required this.isAccepted, required this.requestId});
}