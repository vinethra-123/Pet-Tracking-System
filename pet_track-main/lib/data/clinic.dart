import 'package:cloud_firestore/cloud_firestore.dart';

class Clinic {
  final String id;
  final String description;
  final String image;
  final GeoPoint location;
  final String name;
  final String type;

  Clinic(
    this.id,
    this.description,
    this.image,
    this.location,
    this.name,
    this.type,
  );

  factory Clinic.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> _data = doc.data();
    return Clinic(
      doc.id,
      _data['description'] as String,
      _data['image'] as String,
      _data['location'] as GeoPoint,
      _data['name'] as String,
      _data['type'] as String,
    );
  }

  factory Clinic.empty() =>
      Clinic("", "N/A", "N/A", const GeoPoint(0, 0), "N/A", "N/A");
}
