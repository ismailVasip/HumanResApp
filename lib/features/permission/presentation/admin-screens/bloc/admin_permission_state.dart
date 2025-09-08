part of 'admin_permission_bloc.dart';

sealed class AdminPermissionState {}

final class AdminPermissionInitial extends AdminPermissionState{}

final class AdminPermissionLoading extends AdminPermissionState{}

final class AdminPermissionFailure extends AdminPermissionState{
  final String error;

  AdminPermissionFailure({required this.error});
}

final class AdminAllPermissionsLoaded  extends AdminPermissionState{
  final List<PermissionEntity> list;

  AdminAllPermissionsLoaded ({required this.list});
}

final class AdminActionSuccess extends AdminPermissionState{
  final String message;

  AdminActionSuccess({required this.message});
} 