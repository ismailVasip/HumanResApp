part of 'create_policy_bloc.dart';

sealed class CreatePolicyEvent {}

final class CompanyPolicyCreated extends CreatePolicyEvent{
  final double autoApprovalMaxAmount;
  final List<String> validReasons;
  final int maxInstallments;

  CompanyPolicyCreated({required this.autoApprovalMaxAmount, required this.validReasons, required this.maxInstallments});
}