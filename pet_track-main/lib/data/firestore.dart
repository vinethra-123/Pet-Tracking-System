import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_track/data/clinic.dart';
import 'package:pet_track/data/shop.dart';
import 'package:pet_track/data/vaccination.dart';

class Firestore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Stream<List<Shop>> getShops() {
    return firestore.collection('shops').snapshots().map(
          (e) => e.docs.map((doc) => Shop.fromFirestore(doc)).toList(),
        );
  }

  static Stream<List<Clinic>> getClinics() {
    return firestore.collection('clinics').snapshots().map(
          (e) => e.docs.map((doc) => Clinic.fromFirestore(doc)).toList(),
        );
  }

  static Stream<List<Vaccination>> getVaccinations() {
    return firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection("vaccinations")
        .snapshots()
        .map(
          (e) => e.docs.map((doc) => Vaccination.fromFirestore(doc)).toList(),
        );
  }

  static Future<void> addVaccination(String pet, String doctor, String place,
          DateTime current, DateTime next) =>
      firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection("vaccinations")
          .add({
        "current": current,
        "doctor": doctor,
        "next": next,
        "pet": pet,
        "place": place,
      });

  static Future<void> deleteVaccination(String id) => firestore
      .collection('users')
      .doc(auth.currentUser?.uid)
      .collection("vaccinations")
      .doc(id)
      .delete();

  static Future<LatLng?> getHome() async {
    final profile =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    final home = profile.data()?["home"] as GeoPoint;
    return LatLng(home.latitude, home.longitude);
  }

  static Future<void> setHome(LatLng home) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({"home": GeoPoint(home.latitude, home.longitude)});
  }
}
