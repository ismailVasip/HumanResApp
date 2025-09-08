part of 'assets_mng_bloc.dart';

sealed class AssetsMngEvent {}

final class AssignAssetRequested extends AssetsMngEvent{
  final Asset assetToAssign;

  AssignAssetRequested({required this.assetToAssign});
}

final class CancelAssignmentRequested extends AssetsMngEvent{
  final Asset assetToCancel;

  CancelAssignmentRequested({required this.assetToCancel});
}

final class AssetsFetched extends AssetsMngEvent{
  final String byWho;

  AssetsFetched({required this.byWho});
}
