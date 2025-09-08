class AnnouncementEntity {
  final String id;
  final String adminEmail;
  final String title;
  final String details;
  final DateTime createdDate;

  AnnouncementEntity({
    required this.id,
    required this.adminEmail,
    required this.title,
    required this.details,
    required this.createdDate,
  });
}
