class AdvanceRequestEntity {
  final String id;
  final String userEmail;
  final String adminEmail;
  final double amount;
  final String reason;
  final String status;
  final DateTime requestDate;
  final Map<String,dynamic>? repaymentPlan;

  AdvanceRequestEntity({required this.id, required this.userEmail, required this.adminEmail,required this.amount, required this.reason, required this.status, required this.requestDate, required this.repaymentPlan});
}
