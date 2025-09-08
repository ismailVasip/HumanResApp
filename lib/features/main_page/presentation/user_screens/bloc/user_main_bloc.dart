import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/domain/usecases/get_all_announcements.dart';

part 'user_main_event.dart';
part 'user_main_state.dart';

class UserMainBloc extends Bloc<UserMainEvent, UserMainState> {
  final GetAllAnnouncementsUsecase _getAllAnnouncementsUsecase;
  UserMainBloc({required GetAllAnnouncementsUsecase getAllAnnouncementsUsecase})
    : _getAllAnnouncementsUsecase = getAllAnnouncementsUsecase,
      super(UserMainInitial()) {
    on<UserFetchAnnouncements>(_userFetchAnnouncements);
  }

  FutureOr<void> _userFetchAnnouncements(
    UserFetchAnnouncements event,
    Emitter<UserMainState> emit,
  ) async {
    emit(UserMainLoading());
    final stream = _getAllAnnouncementsUsecase(event.adminEmail);

    await emit.onEach(
      stream,
      onData: (data) {
        data.fold(
          (l) => emit(UserMainFailure(error: l)),
          (list) => emit(UserAnnouncementsFetched(list: list)),
        );
      },
    );
  }
}
