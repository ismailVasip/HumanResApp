part of 'user_assetmng_bloc.dart';

abstract class UserAssetmngState extends Equatable {
  const UserAssetmngState();

  @override
  List<Object?> get props => [];
}

final class UserAssetsMngInitial extends UserAssetmngState {}

final class UserAssetsMngLoading extends UserAssetmngState {
  final bool isFirstFetch;

  const UserAssetsMngLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

final class UserAssetsMngFailure extends UserAssetmngState {
  final String error;

  const UserAssetsMngFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class UserAssetsMngLoaded extends UserAssetmngState {
  final List<Asset> assets;

  const UserAssetsMngLoaded(this.assets);

  @override
  List<Object> get props => [assets];
}

final class ReqSupportLineSendedSuccess extends UserAssetmngState {
  final String message;
  final DateTime timestamp;

  ReqSupportLineSendedSuccess({required this.message}) : timestamp = DateTime.now();

  @override
  List<Object> get props => [message, timestamp];
}
