class Asset {
  final String id;
  final String byWho;
  final String toWho;
  final String brand;
  final String model;
  final String serialNumber;
  final DateTime assignDate;

  Asset({required this.id,required this.byWho, required this.toWho, required this.brand, required this.model, required this.serialNumber, required this.assignDate});
}