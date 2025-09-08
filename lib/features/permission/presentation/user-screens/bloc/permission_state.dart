part of 'permission_block.dart';

sealed class PermissionState {}

final class PermissionInitial extends PermissionState{}

final class PermissionFailure extends PermissionState{
  final String error;

  PermissionFailure({required this.error});
}

final class PermissionLoading extends PermissionState{}

final class PermissionActionSuccess  extends PermissionState{
  final String message;

  PermissionActionSuccess({required this.message});
}

final class PermissionLoaded  extends PermissionState{
  final List<PermissionEntity> list;

  PermissionLoaded ({required this.list});
}