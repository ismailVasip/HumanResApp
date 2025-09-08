String translateName(String name) {
  switch (name) {
    case 'pending':
      return 'Beklemede';
    case 'autoApproved':
      return 'Otomatik Onaylandı';
    case 'manualApproved':
      return 'Onaylandı';
    case 'rejected':
      return 'Reddedildi';
    default:
      return name;
  }
}
