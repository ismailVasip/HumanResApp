import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikproject/features/main_page/domain/entities/announcement_entity.dart';

class AnnouncmentModel extends AnnouncementEntity {
  AnnouncmentModel({
    required super.id,
    required super.adminEmail,
    required super.title,
    required super.details,
    required super.createdDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adminEmail': adminEmail,
      'title': title,
      'details': details,
      'createdDate': createdDate,
    };
  }

  factory AnnouncmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return AnnouncmentModel(
      id: doc.id,
      adminEmail: data?['adminEmail'],
      title: data?['title'],
      details: data?['details'],
      createdDate: (data?['createdDate'] as Timestamp).toDate(),
    );
  }
}
