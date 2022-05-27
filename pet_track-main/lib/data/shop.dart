import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String id;
  final String description;
  final String image;
  final GeoPoint location;
  final String name;

  Shop(this.id, this.description, this.image, this.location, this.name);

  factory Shop.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> _data = doc.data();
    return Shop(
      doc.id,
      _data['description'] as String,
      _data['image'] as String,
      _data['location'] as GeoPoint,
      _data['name'] as String,
    );
  }

  factory Shop.empty() => Shop("", "N/A", "N/A", const GeoPoint(0, 0), "N/A");
}
