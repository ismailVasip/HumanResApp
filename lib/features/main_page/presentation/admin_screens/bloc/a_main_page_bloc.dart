import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';
import 'package:ikproject/features/main_page/domain/entities/user_entity.dart';
import 'package:ikproject/features/main_page/domain/usecases/admin_create_announcement_usecase.dart';
import 'package:ikproject/features/main_page/domain/usecases/admin_get_all_users_usecase.dart';
import 'package:ikproject/features/main_page/domain/usecases/admin_get_support_line_req_usecase.dart';
import 'package:ikproject/features/main_page/domain/usecases/admin_get_user_usecase.dart';
import 'package:ikproject/features/main_page/domain/usecases/admin_update_annual_limit_usecase.dart';
import 'package:ikproject/features/main_page/domain/usecases/get_all_announcements.dart';

part 'a_main_page_event.dart';
part 'a_main_page_state.dart';

class AdminMainPageBloc extends Bloc<AMainPageEvent, AMainPageState> {
  final AdminGetUserUsecase _adminGetUserUsecase;
  final AdminUpdateAnnualLimitUsecase _annualLimitUsecase;
  final AdminGetAllUsersUsecase _adminGetAllUsersUsecase;
  final AdminGetSupportLineReqUsecase _adminGetSupportLineReqUsecase;
  final GetAllAnnouncementsUsecase _getAllAnnouncementsUsecase;
  final AdminCreateAnnouncementUsecase _adminCreateAnnouncementUsecase;

  AdminMainPageBloc({
    required AdminGetUserUsecase adminGetUserUsecase,
    required AdminUpdateAnnualLimitUsecase adminUpdateFinancialsUsecase,
    required AdminGetAllUsersUsecase adminGetAllUsersUsecase,
    required AdminGetSupportLineReqUsecase adminGetSupportLineReqUsecase,
    required GetAllAnnouncementsUsecase getAllAnnouncementsUsecase,
    required AdminCreateAnnouncementUsecase adminCreateAnnouncementUsecase,
  }) : _adminGetUserUsecase = adminGetUserUsecase,
       _annualLimitUsecase = adminUpdateFinancialsUsecase,
       _adminGetAllUsersUsecase = adminGetAllUsersUsecase,
       _adminGetSupportLineReqUsecase = adminGetSupportLineReqUsecase,
       _getAllAnnouncementsUsecase = getAllAnnouncementsUsecase,
       _adminCreateAnnouncementUsecase = adminCreateAnnouncementUsecase,
       super(AdminMainPageInitial()) {
    on<AdminUserLoaded>(_adminUserLoaded);
    on<AdminFinancialsUpdated>(_adminFinancialsUpdated);
    on<AdminFetchAllUsers>(_adminFetchAllUsers);
    on<AdminFetchAllSupportLineReq>(_adminFetchAllSupportLineReq);
    on<AdminCreateAnnouncementReq>(_adminCreateAnnouncementReq);
    on<FetchAllAnnouncements>(_fetchAllAnnouncements);
  }

  FutureOr<void> _adminUserLoaded(
    AdminUserLoaded event,
    Emitter<AMainPageState> emit,
  ) async {
    emit(AdminMainPageSearchUserLoading());

    final result = await _adminGetUserUsecase(
      GetUserParams(adminEmail: event.adminEmail, userEmail: event.userEmail),
    );

    result.fold(
      (l) => emit(AdminMainPageFailure(error: l)),
      (r) => emit(AdminMainPageUserFetched(user: r)),
    );
  }

  FutureOr<void> _adminFinancialsUpdated(
    AdminFinancialsUpdated event,
    Emitter<AMainPageState> emit,
  ) async {
    emit(AdminMainPageUpdateFinancialLoading());

    final result = await _annualLimitUsecase(
      UpdateUserFinancialsParams(
        userEmail: event.userEmail,
        newAnnualLimit: event.newAnnualLimit,
      ),
    );

    result.fold(
      (l) => emit(AdminMainPageFailure(error: l)),
      (r) => emit(AdminMainPageActionSuccess(message: 'Güncelleme başarılı.')),
    );
  }

  FutureOr<void> _adminFetchAllUsers(
    AdminFetchAllUsers event,
    Emitter<AMainPageState> emit,
  ) async {
    emit(AdminMainPageGetUsersLoading());

    final result = await _adminGetAllUsersUsecase(event.adminEmail);

    result.fold(
      (l) => emit(AdminMainPageFailure(error: l)),
      (r) => emit(AdminAllUsersFetched(list: r)),
    );
  }

  FutureOr<void> _adminFetchAllSupportLineReq(
    AdminFetchAllSupportLineReq event,
    Emitter<AMainPageState> emit,
  ) async {
    emit(AdminMainPageSupportLineLoading());

    final result = await _adminGetSupportLineReqUsecase(event.adminEmail);

    result.fold(
      (l) => emit(AdminMainPageFailure(error: l)),
      (r) => emit(AdminAllSupportLineReqFetched(entity: r)),
    );
  }

  FutureOr<void> _adminCreateAnnouncementReq(
    AdminCreateAnnouncementReq event,
    Emitter<AMainPageState> emit,
  ) async {
    emit(AdminMainPageCreateAnnouncementLoading());

    final result = await _adminCreateAnnouncementUsecase(event.entity);

    result.fold(
      (l) => emit(AdminMainPageFailure(error: l)),
      (r) => emit(AdminAnnouncementCreated(message: 'İşlem Başarılı')),
    );
  }

  FutureOr<void> _fetchAllAnnouncements(
    FetchAllAnnouncements event,
    Emitter<AMainPageState> emit,
  ) async {
    emit(AdminMainPageFetchAllAnnouncementsLoading());

    final stream = _getAllAnnouncementsUsecase(event.adminEmail);

    await emit.onEach(
      stream,
      onData: (data) {
        data.fold(
          (l) => emit(AdminMainPageFailure(error: l)),
          (list) => emit(AdminAllAnnouncementsFetched(list: list)),
        );
      },
    );
  }
}
