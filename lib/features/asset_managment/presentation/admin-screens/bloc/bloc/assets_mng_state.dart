part of 'assets_mng_bloc.dart';

abstract class AssetsMngState extends Equatable {
  const AssetsMngState();

  @override
  List<Object> get props => [];
}

final class AssetsMngInitial extends AssetsMngState {}

final class AssetsMngLoading extends AssetsMngState {
  final bool isFirstFetch;

  const AssetsMngLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

final class AssetsMngFailure extends AssetsMngState {
  final String error;

  const AssetsMngFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class AssetsMngActionSuccess extends AssetsMngState {
  final String message;

  const AssetsMngActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AssetsMngLoaded extends AssetsMngState {
  final List<Asset> assets;

  const AssetsMngLoaded(this.assets);

  @override
  List<Object> get props => [assets];
}
