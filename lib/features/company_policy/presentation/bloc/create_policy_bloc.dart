import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/company_policy/domain/usecases/create_company_policy_usecase.dart';

part 'create_policy_event.dart';
part 'create_policy_state.dart';

class CreatePolicyBloc extends Bloc<CreatePolicyEvent, CreatePolicyState> {
  final CreateCompanyPolicyUsecase _createCompanyPolicyUsecase;
  CreatePolicyBloc({
    required CreateCompanyPolicyUsecase createCompanyPolicyUsecase,
  }) : _createCompanyPolicyUsecase = createCompanyPolicyUsecase,
       super(CreatePolicyInitial()) {
    on<CompanyPolicyCreated>(_companyPolicyCreated);
  }

  FutureOr<void> _companyPolicyCreated(
    CompanyPolicyCreated event,
    Emitter<CreatePolicyState> emit,
  ) async {
    emit(CreatePolicyLoading());

    final result = await _createCompanyPolicyUsecase(
      PolicyParams(
        autoApprovalMaxAmount: event.autoApprovalMaxAmount,
        validReasons: event.validReasons,
        maxInstallments: event.maxInstallments,
      ),
    );

    result.fold(
      (l) => emit(CreatePolicyFailure(error: l)),
      (r) => emit(CreatedCompanyPolicy()),
    );
  }
}
