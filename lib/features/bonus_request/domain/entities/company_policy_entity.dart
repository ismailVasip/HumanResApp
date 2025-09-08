class CompanyPolicyEntity {
  final double? autoApprovalMaxAmount;
  final List<String>? validReasons;
  final int? maxInstallments;

  CompanyPolicyEntity({required this.autoApprovalMaxAmount, required this.validReasons, required this.maxInstallments});
}