part of 'admin_bonus_bloc.dart';

sealed class AdminBonusState {}

final class AdminBonusInitial extends AdminBonusState{}

final class AdminBonusFailure extends AdminBonusState{
  final String error;

  AdminBonusFailure({required this.error});
}

final class AdminBonusLoading extends AdminBonusState{}

final class AdminUpdatedReqStatusSuccess extends AdminBonusState{
  final String message;

  AdminUpdatedReqStatusSuccess({required this.message});
}

final class AdminFetchedReqsSuccess extends AdminBonusState{
  final List<AdvanceRequestEntity> list;

  AdminFetchedReqsSuccess({required this.list});
}