import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/asset_managment/domain/usecases/user_get_assets_usecase.dart';
import 'package:ikproject/features/asset_managment/domain/usecases/user_send_req_support_line.dart';

part 'user_assetmng_state.dart';
part 'user_assetmng_event.dart';

class UserAssetsMngBloc extends Bloc<UserAssetsMngEvent, UserAssetmngState> {
  final UserGetAssetsUsecase _userGetAssetsUsecase;
  final UserSendReqSupportLine _reqSupportLine;

  UserAssetsMngBloc({
    required UserGetAssetsUsecase userGetAssetsUsecase,
    required UserSendReqSupportLine reqSupportLine,
  }) : _userGetAssetsUsecase = userGetAssetsUsecase,
       _reqSupportLine = reqSupportLine,
       super(UserAssetsMngInitial()) {
    on<AssetsFetched>(_assetsFetched);
    on<AssetsSupportLine>(_assetsSupportLine);
  }

  FutureOr<void> _assetsFetched(
    AssetsFetched event,
    Emitter<UserAssetmngState> emit,
  ) async {
    emit(UserAssetsMngLoading(isFirstFetch: true));

    final streamResult = _userGetAssetsUsecase(event.toWho);

    await emit.onEach<Either<String, List<Asset>>>(
      streamResult,
      onData: (eitherResult) {
        eitherResult.fold(
          (failure) => emit(UserAssetsMngFailure(failure)),
          (assetList) => emit(UserAssetsMngLoaded(assetList)),
        );
      },
      onError: (error, stackTrace) {
        emit(UserAssetsMngFailure(error.toString()));
      },
    );
  }

  FutureOr<void> _assetsSupportLine(
    AssetsSupportLine event,
    Emitter<UserAssetmngState> emit,
  ) async {
    final result = await _reqSupportLine(
      SupportLineEntity(
        id: event.entity.id,
        adminEmail: event.entity.adminEmail,
        userEmail: event.entity.userEmail,
        request: event.entity.request,
      ),
    );

    result.fold(
      (l) => emit(UserAssetsMngFailure(l)),
      (r) =>
          emit(ReqSupportLineSendedSuccess(message: 'Mesajınız iletilmiştir.')),
    );
  }
}
