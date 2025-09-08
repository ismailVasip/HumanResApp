import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/permission/domain/entities/permission_entity.dart';
import 'package:ikproject/features/permission/domain/usecases/admin_evaluate_request_usecase.dart';
import 'package:ikproject/features/permission/domain/usecases/admin_get_all_permissions_usecase.dart';

part 'admin_permission_event.dart';
part 'admin_permission_state.dart';

class AdminPermissionBloc
    extends Bloc<AdminPermissionEvent, AdminPermissionState> {
  final AdminGetAllPermissionsUsecase _adminGetAllPermissionsUsecase;
  final AdminEvaluateRequestUsecase _adminEvaluateRequestUsecase;
  AdminPermissionBloc({
    required AdminGetAllPermissionsUsecase adminGetAllPermissionsUsecase,
    required AdminEvaluateRequestUsecase adminEvaluateRequestUsecase,
  }) : _adminGetAllPermissionsUsecase = adminGetAllPermissionsUsecase,
       _adminEvaluateRequestUsecase = adminEvaluateRequestUsecase,
       super(AdminPermissionInitial()) {
    on<AllPermissionsFetched>(_allPermissionsFetched);
    on<RequestEvaluated>(_requestEvaluated);
  }

  FutureOr<void> _allPermissionsFetched(
    AllPermissionsFetched event,
    Emitter<AdminPermissionState> emit,
  ) async {
    emit(AdminPermissionLoading());

    final result = _adminGetAllPermissionsUsecase(event.adminEmail);

    await emit.onEach(
      result,
      onData: (data) {
        data.fold(
          (l) => emit(AdminPermissionFailure(error: l)),
          (list) => emit(AdminAllPermissionsLoaded(list: list)),
        );
      },
      onError: (error, stackTrace) {
        emit(AdminPermissionFailure(error: error.toString()));
      },
    );
  }

  FutureOr<void> _requestEvaluated(
    RequestEvaluated event,
    Emitter<AdminPermissionState> emit,
  ) async {
    emit(AdminPermissionLoading());

    final result = await _adminEvaluateRequestUsecase(
      AdminEvaluateRequestParams(
        isAccepted: event.isAccepted,
        requestId: event.requestId,
      ),
    );

    result.fold((l) => emit(AdminPermissionFailure(error: l)), (r) {
      final message = event.isAccepted
          ? "İzin talebi onaylandı."
          : "İzin talebi reddedildi.";
      emit(AdminActionSuccess(message: message));
    });
  }
}
