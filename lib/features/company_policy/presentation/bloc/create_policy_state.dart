part of 'create_policy_bloc.dart';

sealed class CreatePolicyState {}

final class CreatePolicyInitial extends CreatePolicyState {}

final class CreatePolicyLoading extends CreatePolicyState {}

final class CreatePolicyFailure extends CreatePolicyState {
  final String error;

  CreatePolicyFailure({required this.error});
}

final class CreatedCompanyPolicy extends CreatePolicyState {}
