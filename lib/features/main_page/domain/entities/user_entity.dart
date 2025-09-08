class UserEntity {
  final String? fullName;
  final String? email;
  final List<String>? role;
  final Map<String, dynamic>? financials;

  UserEntity({
    required this.fullName,
    required this.email,
    required this.role,
    required this.financials,
  });
}
