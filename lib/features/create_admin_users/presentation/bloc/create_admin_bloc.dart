import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/create_admin_users/domain/usecases/create_admin_usecase.dart';
import 'package:ikproject/features/create_admin_users/domain/usecases/match_admin_and_user_usecase.dart';

part 'create_admin_event.dart';
part 'create_admin_state.dart';

class CreateAdminBloc extends Bloc<CreateAdminEvent, CreateAdminState> {
  final CreateAdminUsecase _createAdminUsecase;
  final MatchAdminAndUserUsecase _matchAdminAndUserUsecase;

  CreateAdminBloc({required CreateAdminUsecase createAdminUsecase,
  required MatchAdminAndUserUsecase matchAdminAndUserUsecase})
    : _createAdminUsecase = createAdminUsecase,
      _matchAdminAndUserUsecase = matchAdminAndUserUsecase,
      super(CreateAdminInitial()) {
    on<CreateUserWithAdminRoleEvent>(_createUserWithAdminRoleEvent);
    on<MatchAdminAndUserEvent>(_matchAdminAndUserEvent);
  }

  FutureOr<void> _createUserWithAdminRoleEvent(
    CreateUserWithAdminRoleEvent event,
    Emitter<CreateAdminState> emit,
  ) async{
    emit(CreateAdminLoading());

    final result = await _createAdminUsecase(CreateAdminParams(email: event.email));

    result.fold(
      (l) => emit(CreateAdminFailure(error: l)),
      (r) => emit(CreateAdminSuccess())
    );
  }

  FutureOr<void> _matchAdminAndUserEvent(MatchAdminAndUserEvent event, Emitter<CreateAdminState> emit) async{
    emit(MatchAdminAndUserLoading());

    final result = await _matchAdminAndUserUsecase(MathcingParams(adminEmail: event.adminEmail, userEmail: event.userEmail));

    result.fold(
      (l) => emit(CreateAdminFailure(error: l)),
      (r) => emit(MatchAdminAndUserSuccess())
    );
  }
}
