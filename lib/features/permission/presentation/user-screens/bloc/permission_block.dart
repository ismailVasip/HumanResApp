import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/usecases/ask_permission_usecase.dart';
import 'package:ikproject/features/permission/domain/usecases/get_my_permissions_usecase.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final GetMyPermissionsUsecase _getMyPermissionsUsecase;
  final AskPermissionUsecase _askPermissionUsecase;
  PermissionBloc({
    required GetMyPermissionsUsecase getMyPermissionUsecase,
    required AskPermissionUsecase askPermissionUsecase,
  }) : _getMyPermissionsUsecase = getMyPermissionUsecase,
       _askPermissionUsecase = askPermissionUsecase,
       super(PermissionInitial()) {
    on<AskPermissionRequested>(_askPermissionRequested);
    on<MyPermissionsFetched>(_myPermissionsFetched);
  }

  FutureOr<void> _askPermissionRequested(
    AskPermissionRequested event,
    Emitter<PermissionState> emit,
  ) async {
    emit(PermissionLoading());

    final result = await _askPermissionUsecase(event.entity);

    result.fold(
      (l) => emit(PermissionFailure(error: l)),
      (r) => emit(PermissionActionSuccess(message: 'İzin talebiniz iletildi.')),
    );
  }

  Future<void> _myPermissionsFetched(
    MyPermissionsFetched event,
    Emitter<PermissionState> emit,
  ) async{
    emit(PermissionLoading());

    final result = _getMyPermissionsUsecase(event.userEmail);

    await emit.onEach(
      result,
      onData: (data) {
        data.fold(
          (l) => emit(PermissionFailure(error: l)),
          (list) => emit(PermissionLoaded(list: list)),
        );
      },
      onError: (error, stackTrace) {
        emit(PermissionFailure(error: error.toString()));
      },
    );
  }
}
