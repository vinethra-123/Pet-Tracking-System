import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:pet_track/data/firestore.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase db = FirebaseDatabase.instance;
  late String _mapStyle;
  late BitmapDescriptor _homeMarker;
  LatLng? _myPosition;
  LatLng? _homePosition;
  LatLng? _pickedPosition;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 18,
  );
  late GoogleMapController _mapController;
  late StreamSubscription<Position> _positionStream;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );
  Set<Marker> _markers = {};

  void listenToLocationChanges() async {
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      LatLng pos = LatLng(position.latitude, position.longitude);
      if (_myPosition == null) {
        _mapController.animateCamera(CameraUpdate.newLatLng(pos));
      }
      setState(() {
        _myPosition = pos;
      });
    });
  }

  Marker get getHomeMarker => Marker(
        markerId: const MarkerId("home1"),
        position: _homePosition!,
        icon: _homeMarker,
        anchor: const Offset(.5, .5),
      );

  void deviceLocations() {
    DatabaseReference ref = db.ref("devices");
    ref.onValue.listen((event) async {
      await getHomeLocation();
      Set<Marker> out = {};
      for (var child in event.snapshot.children) {
        List<String> latLng = child.value.toString().split(",");
        LatLng pos = LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
        num dist = 1000;
        if (_homePosition != null) {
          dist = mt.SphericalUtil.computeDistanceBetween(
            mt.LatLng(_homePosition!.latitude, _homePosition!.longitude),
            mt.LatLng(pos.latitude, pos.longitude),
          );
        }

        out.add(
          Marker(
            markerId: MarkerId(child.key ?? Random().nextInt(30).toString()),
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(getColorFromDist(dist)),
          ),
        );
      }
      if (mounted) setState(() => _markers = out);
    });
  }

  double getColorFromDist(num dist) {
    if (dist < 200) {
      return BitmapDescriptor.hueGreen;
    } else if (dist < 350) {
      return BitmapDescriptor.hueOrange;
    }
    return BitmapDescriptor.hueRed;
  }

  Future<void> getHomeLocation() async {
    _homeMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/home.png",
    );
    _homePosition = await Firestore.getHome();
    setState(() {});
    //  _markers.add(getHomeMarker);
  }

  Set<Circle> getColorCircles() => {
        Circle(
          circleId: const CircleId("c3"),
          center: _homePosition!,
          radius: 500,
          fillColor: Colors.redAccent.withOpacity(.1),
          strokeColor: Colors.redAccent,
          strokeWidth: 3,
        ),
        Circle(
          circleId: const CircleId("c2"),
          center: _homePosition!,
          radius: 350,
          fillColor: Colors.orangeAccent.withOpacity(.1),
          strokeColor: Colors.orangeAccent,
          strokeWidth: 3,
        ),
        Circle(
          circleId: const CircleId("c1"),
          center: _homePosition!,
          radius: 200,
          fillColor: Colors.greenAccent.withOpacity(.2),
          strokeColor: Colors.green,
          strokeWidth: 3,
        ),
      };

  @override
  void initState() {
    rootBundle
        .loadString('assets/map_style.txt')
        .then((string) => _mapStyle = string);
    deviceLocations();
    listenToLocationChanges();
    getHomeLocation();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _positionStream.cancel();
    super.dispose();
  }

  void handleMenu(String value) {
    switch (value) {
      case 'Logout':
        Get.defaultDialog(
          title: "Are you sure?",
          content: const Text("You will be signed out from the app"),
          onConfirm: () => auth.signOut(),
          onCancel: () => {},
        );
        break;
      case 'Save as home':
        if (_pickedPosition != null) {
          Firestore.setHome(_pickedPosition!);
          getHomeLocation();
          _pickedPosition = null;
        } else {
          Get.snackbar(
            "Please pick a location",
            "Long press on the map to select a location the save it",
            icon: const Icon(Icons.pin_drop_rounded),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pet Track"),
        backgroundColor: Colors.blueAccent,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w300,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleMenu,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Save as home'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        // zoomControlsEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) {
          _mapController = controller;
          _mapController.setMapStyle(_mapStyle);
        },
        onLongPress: (picked) => setState(() => _pickedPosition = picked),
        markers: {
          ..._markers,
          if (_pickedPosition != null)
            Marker(
              markerId: const MarkerId("home"),
              position: _pickedPosition!,
            ),
        },
        minMaxZoomPreference: const MinMaxZoomPreference(8, 21),
        circles: _homePosition != null ? getColorCircles() : {},
      ),
    );
  }
}
