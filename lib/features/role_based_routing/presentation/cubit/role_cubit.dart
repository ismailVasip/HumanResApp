import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/role_based_routing/domain/usecases/get_role_usecase.dart';
import 'package:ikproject/features/role_based_routing/presentation/cubit/role_state.dart';

class RoleCubit extends Cubit<RoleState> {
  final GetRoleUsecase getRoleUsecase;

  RoleCubit({required this.getRoleUsecase}) : super(RoleInitial());

  void _safeEmit(RoleState state) {
    if (!isClosed) emit(state);
  }

  Future<void> getUserRole() async {
    if (isClosed) return; // Kapandıysa hiç başlama

    _safeEmit(RoleLoading());

    final result = await getRoleUsecase(NoParams());

    if (isClosed) return; // await sonrası tekrar kontrol

    result.fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        _safeEmit(RoleError(message));
      },
      (role) {
        _safeEmit(RoleLoaded(role.$1, role.$2 ?? 'user'));
      },
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    return "Beklenmeyen bir hata oluştu.";
  }
}
