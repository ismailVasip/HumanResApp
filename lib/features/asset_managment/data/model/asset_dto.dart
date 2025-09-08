import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';

class AssetDto extends Asset {
  AssetDto({
    required super.id,
    required super.byWho,
    required super.toWho,
    required super.brand,
    required super.model,
    required super.serialNumber,
    required super.assignDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'byWho': byWho,
      'toWho': toWho,
      'brand': brand,
      'model': model,
      'serialNumber': serialNumber,
      'assignDate': assignDate,
    };
  }

  factory AssetDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AssetDto(
      id: doc.id,//firestore dan geliyor
      byWho: data['byWho'] ?? '',
      toWho: data['toWho'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      serialNumber: data['serialNumber'] ?? '',
      assignDate: (data['assignDate'] as Timestamp).toDate(),
    );
  }
}
