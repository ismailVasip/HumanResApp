class CreateCompanyPolicyEntity {
  final double autoApprovalMaxAmount;
  final List<String> validReasons;
  final int maxInstallments;

  CreateCompanyPolicyEntity({
    required this.autoApprovalMaxAmount,
    required this.validReasons,
    required this.maxInstallments,
  });
}
