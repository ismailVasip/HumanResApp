import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/domain/entities/company_policy_entity.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';
import 'package:ikproject/features/bonus_request/domain/usecases/create_advance_req_usecased.dart';
import 'package:ikproject/features/bonus_request/domain/usecases/get_company_policy_usecase.dart';
import 'package:ikproject/features/bonus_request/domain/usecases/get_user_advance_req_usecase.dart';
import 'package:ikproject/features/bonus_request/domain/usecases/get_user_financials_usecase.dart';

part 'user_bonus_event.dart';
part 'user_bonus_state.dart';

class UserBonusBloc extends Bloc<UserBonusEvent, UserBonusState> {
  final CreateAdvanceReqUsecase _createAdvanceReqUsecase;
  final GetCompanyPolicyUsecase _getCompanyPolicyUsecase;
  final GetUserAdvanceReqUsecase _getUserAdvanceReqUsecase;
  final GetUserFinancialsUsecase _getUserFinancialsUsecase;

  UserBonusBloc({
    required CreateAdvanceReqUsecase createAdvanceReqUsecase,
    required GetCompanyPolicyUsecase getCompanyPolicyUsecase,
    required GetUserAdvanceReqUsecase getUserAdvanceReqUsecase,
    required GetUserFinancialsUsecase getUserFinancialsUsecase,
  }) : _createAdvanceReqUsecase = createAdvanceReqUsecase,
       _getCompanyPolicyUsecase = getCompanyPolicyUsecase,
       _getUserAdvanceReqUsecase = getUserAdvanceReqUsecase,
       _getUserFinancialsUsecase = getUserFinancialsUsecase,
       super(UserBonusInitial()) {
    on<UserCreateAdvanceReq>(_userCreateAdvanceReq);
    on<UserFetchAdvanceReqs>(_userFetchAdvanceReqs);
    on<UserFetchCompanyPolicy>(_userFetchCompanyPolicy);
    on<UserGetFinancials>(_userGetFinancials);
  }

  FutureOr<void> _userCreateAdvanceReq(
    UserCreateAdvanceReq event,
    Emitter<UserBonusState> emit,
  ) async {
    emit(UserBonusLoading());

    final result = await _createAdvanceReqUsecase(
      CreateAdvanceReqParams(
        entity: AdvanceRequestEntity(
          id: event.entity.id,
          userEmail: event.entity.userEmail,
          adminEmail: event.entity.adminEmail,
          amount: event.entity.amount,
          reason: event.entity.reason,
          status: event.entity.status,
          requestDate: event.entity.requestDate,
          repaymentPlan: event.entity.repaymentPlan,
        ),
        newRemainingLimit: event.newRemainingLimit,
      ),
    );

    return result.fold(
      (l) => emit(UserBonusFailure(error: l)),
      (r) => emit(UserAdvanceReqCreated()),
    );
  }

  FutureOr<void> _userFetchAdvanceReqs(
    UserFetchAdvanceReqs event,
    Emitter<UserBonusState> emit,
  ) async {
    emit(UserBonusLoading());

    final result = _getUserAdvanceReqUsecase(event.userEmail);

    await emit.onEach(
      result,
      onData: (data) {
        data.fold(
          (l) => emit(UserBonusFailure(error: l)),
          (r) => emit(UserAllFinancialsFetched(list: r)),
        );
      },
    );
  }

  FutureOr<void> _userFetchCompanyPolicy(
    UserFetchCompanyPolicy event,
    Emitter<UserBonusState> emit,
  ) async {
    emit(UserBonusLoading());

    final result = await _getCompanyPolicyUsecase(NoParams());

    return result.fold(
      (l) => emit(UserBonusFailure(error: l)),
      (r) => emit(UserCompanyPolicyFetched(entity: r)),
    );
  }

  FutureOr<void> _userGetFinancials(
    UserGetFinancials event,
    Emitter<UserBonusState> emit,
  ) async {
    emit(UserBonusLoading());

    final result = _getUserFinancialsUsecase(event.userEmail);

    await emit.onEach(
      result,
      onData: (data) {
        data.fold(
          (l) => emit(UserBonusFailure(error: l)),
          (r) => emit(UserFinancialsFetched(entity: r)),
        );
      },
    );
  }
}
