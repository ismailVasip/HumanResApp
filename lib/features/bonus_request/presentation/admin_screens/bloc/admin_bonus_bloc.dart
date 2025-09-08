import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/core/enums/request_status_enum.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/domain/usecases/get_admin_advance_req_usecase.dart';
import 'package:ikproject/features/bonus_request/domain/usecases/update_req_status_usecase.dart';

part 'admin_bonus_event.dart';
part 'admin_bonus_state.dart';

class AdminBonusBloc extends Bloc<AdminBonusEvent, AdminBonusState> {
  final UpdateReqStatusUsecase _updateReqStatusUsecase;
  final GetAdminAdvanceReqUsecase _getPendingReqUsecase;

  AdminBonusBloc({
    required UpdateReqStatusUsecase updateReqStatusUsecase,
    required GetAdminAdvanceReqUsecase getPendingReqUsecase,
  }) : _updateReqStatusUsecase = updateReqStatusUsecase,
       _getPendingReqUsecase = getPendingReqUsecase,
       super(AdminBonusInitial()) {
    on<AdminRequestStatusUpdate>(_adminRequestStatusUpdate);
    on<AdminPendingRequestsFetch>(_adminPendingRequestsFetch);
  }

  FutureOr<void> _adminRequestStatusUpdate(
    AdminRequestStatusUpdate event,
    Emitter<AdminBonusState> emit,
  ) async {
    emit(AdminBonusLoading());

    final result = await _updateReqStatusUsecase(
      UpdateReqStatusParams(
        reqId: event.reqId,
        userEmail: event.userEmail,
        amount: event.amount,
        newStatus: event.newStatus,
      ),
    );

    return result.fold(
      (l) => emit(AdminBonusFailure(error: l)),
      (r) => emit(AdminUpdatedReqStatusSuccess(message: 'İşlem Başarılı.')),
    );
  }

  FutureOr<void> _adminPendingRequestsFetch(
    AdminPendingRequestsFetch event,
    Emitter<AdminBonusState> emit,
  ) async {
    emit(AdminBonusLoading());

    final result = _getPendingReqUsecase(event.adminEmail);

    await emit.onEach(
      result,
      onData: (data) {
        data.fold(
          (l) => emit(AdminBonusFailure(error: l)),
          (r) => emit(AdminFetchedReqsSuccess(list: r)),
        );
      },
    );
  }
}
