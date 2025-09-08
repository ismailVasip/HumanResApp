part of 'user_bonus_bloc.dart';

sealed class UserBonusEvent {}

final class UserCreateAdvanceReq extends UserBonusEvent{
  final AdvanceRequestEntity entity;
  final double newRemainingLimit;

  UserCreateAdvanceReq({required this.entity, required this.newRemainingLimit});
}

final class UserFetchAdvanceReqs extends UserBonusEvent{
  final String userEmail;

  UserFetchAdvanceReqs({required this.userEmail});
}

final class UserFetchCompanyPolicy extends UserBonusEvent{}

final class UserGetFinancials extends UserBonusEvent{
  final String userEmail;

  UserGetFinancials({required this.userEmail});
}


