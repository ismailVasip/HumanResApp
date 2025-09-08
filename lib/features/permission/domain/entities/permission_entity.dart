class PermissionEntity {
  final String id;
  final String type;
  final String cause;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdDate;
  final String status;
  final String userEmail;
  final String? adminEmail;

  PermissionEntity({
    required this.id,
    required this.type,
    required this.cause,
    required this.startDate,
    required this.endDate,
    required this.createdDate,
    required this.status,
    required this.userEmail,
    required this.adminEmail,
  });
}
