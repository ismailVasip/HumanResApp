part of 'user_assetmng_bloc.dart';

sealed class UserAssetsMngEvent {}

final class AssetsFetched extends UserAssetsMngEvent {
  final String toWho;

  AssetsFetched({required this.toWho});
}

final class AssetsSupportLine extends UserAssetsMngEvent {
  final SupportLineEntity entity;

  AssetsSupportLine({required this.entity});
}
