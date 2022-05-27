import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccination {
  final String id;
  final String doctor;
  final DateTime current;
  final DateTime next;
  final String pet;
  final String place;

  Vaccination(
    this.id,
    this.doctor,
    this.current,
    this.next,
    this.pet,
    this.place,
  );

  factory Vaccination.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> _data = doc.data();
    return Vaccination(
      doc.id,
      _data['doctor'] as String,
      (_data['current'] as dynamic).toDate(),
      (_data['next'] as dynamic).toDate(),
      _data['pet'] as String,
      _data['place'] as String,
    );
  }
}
