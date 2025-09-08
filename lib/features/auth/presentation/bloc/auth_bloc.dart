import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/auth/domain/usecases/auth_state_change_usecase.dart';
import 'package:ikproject/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:ikproject/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ikproject/features/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogOutUsecase _logOutUsecase;
  final AuthStateChangeUsecase _authStateChangeUsecase;

  StreamSubscription<User?>? _userSubscription;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required LogOutUsecase logOutUsecase,
    required AuthStateChangeUsecase authStateChangeUsecase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _logOutUsecase = logOutUsecase,
       _authStateChangeUsecase = authStateChangeUsecase,
       super(AuthInitial()) {
    _userSubscription = _authStateChangeUsecase(NoParamsAuthState()).listen((
      user,
    ) {
      if (!isClosed) {
        add(AuthUserChanged(user));
      }
    });

    on<AuthSignUp>(_signUp);
    on<AuthSignIn>(_signIn);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  void _signUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _signUpUseCase(
      SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold((l) => emit(AuthFailure(l)), (r) {
      emit(AuthSuccess(r));
    });
  }

  void _signIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold((l) => emit(AuthFailure(l)), (r) {
      emit(AuthSuccess(r));
    });
  }

  FutureOr<void> _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthSuccess(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  FutureOr<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logOutUsecase(NoParamsForLogout());
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    _userSubscription = null;
    return super.close();
  }
}
