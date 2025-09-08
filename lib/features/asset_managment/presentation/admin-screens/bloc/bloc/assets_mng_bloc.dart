import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/usecases/admin_assign_asset_usecase.dart';
import 'package:ikproject/features/asset_managment/domain/usecases/admin_cancel_assign_usecase.dart';
import 'package:ikproject/features/asset_managment/domain/usecases/admin_get_assets_usecase.dart';

part 'assets_mng_event.dart';
part 'assets_mng_state.dart';

class AssetsMngBloc extends Bloc<AssetsMngEvent, AssetsMngState> {
  final AdminAssignassetUsecase _adminAssignassetUsecase;
  final AdminCancelAssignUsecase _adminCancelAssignUsecase;
  final AdminGetAssetsUsecase _adminGetAssetsUsecase;

  AssetsMngBloc({
    required AdminAssignassetUsecase adminAssignassetUsecase,
    required AdminCancelAssignUsecase adminCancelAssignUsecase,
    required AdminGetAssetsUsecase adminGetAssetsUsecase,
  }) : _adminAssignassetUsecase = adminAssignassetUsecase,
       _adminCancelAssignUsecase = adminCancelAssignUsecase,
       _adminGetAssetsUsecase = adminGetAssetsUsecase,
       super(AssetsMngInitial()) {
    on<AssignAssetRequested>(_assignAssetRequested);
    on<CancelAssignmentRequested>(_cancelAssignmentRequested);
    on<AssetsFetched>(_assetsFetched);
  }

  FutureOr<void> _assignAssetRequested(
    AssignAssetRequested event,
    Emitter<AssetsMngState> emit,
  ) async {
    emit(AssetsMngLoading(isFirstFetch: false));

    final result = await _adminAssignassetUsecase(event.assetToAssign);

    result.fold(
      (failure) => emit(AssetsMngFailure(failure)),

      (success) =>
          emit(const AssetsMngActionSuccess("Zimmet başarıyla oluşturuldu.")),
    );
  }

  FutureOr<void> _cancelAssignmentRequested(
    CancelAssignmentRequested event,
    Emitter<AssetsMngState> emit,
  ) async {
    emit(AssetsMngLoading(isFirstFetch: false));

    final result = await _adminCancelAssignUsecase(event.assetToCancel);

    result.fold(
      (failure) => emit(AssetsMngFailure(failure)),

      (success) =>
          emit(const AssetsMngActionSuccess("Zimmet başarıyla silindi.")),
    );
  }

  Future<void> _assetsFetched(
    AssetsFetched event,
    Emitter<AssetsMngState> emit,
  ) async {
    emit(AssetsMngLoading(isFirstFetch: true));

    final streamResult = _adminGetAssetsUsecase(event.byWho);

    await emit.onEach<Either<String, List<Asset>>>(
      streamResult,
      onData: (eitherResult) {
        eitherResult.fold(
          (failure) => emit(AssetsMngFailure(failure)),
          (assetList) => emit(AssetsMngLoaded(assetList)),
        );
      },
      onError: (error, stackTrace) {
        emit(AssetsMngFailure(error.toString()));
      },
    );
  }
}
