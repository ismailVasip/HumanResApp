part of 'user_bonus_bloc.dart';

sealed class UserBonusState {}

final class UserBonusInitial extends UserBonusState{}

final class UserBonusFailure extends UserBonusState{
  final String error;

  UserBonusFailure({required this.error});
}

final class UserBonusLoading extends UserBonusState{}

final class UserFinancialsFetched extends UserBonusState{
  final UserFinancialsEntity entity;

  UserFinancialsFetched({required this.entity});
}

final class UserAdvanceReqCreated extends UserBonusState{
}

final class UserAllFinancialsFetched extends UserBonusState{
  final List<AdvanceRequestEntity> list;

  UserAllFinancialsFetched({required this.list});
}

final class UserCompanyPolicyFetched extends UserBonusState{
  final CompanyPolicyEntity entity;

  UserCompanyPolicyFetched({required this.entity});
}