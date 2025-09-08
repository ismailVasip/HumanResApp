enum RequestStatus {
  pending,

  autoApproved,

  manualApproved,

  rejected;

  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Beklemede';
      case RequestStatus.autoApproved:
        return 'Otomatik Onaylandı';
      case RequestStatus.manualApproved:
        return 'Onaylandı';
      case RequestStatus.rejected:
        return 'Reddedildi';
    }
  }
}
