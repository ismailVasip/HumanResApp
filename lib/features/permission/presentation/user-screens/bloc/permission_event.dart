part of 'permission_block.dart';


sealed class PermissionEvent {}

final class AskPermissionRequested  extends PermissionEvent{
  final PermissionEntity entity;

  AskPermissionRequested ({required this.entity});
}

final class MyPermissionsFetched  extends PermissionEvent{
  final String userEmail;

  MyPermissionsFetched ({required this.userEmail});
}