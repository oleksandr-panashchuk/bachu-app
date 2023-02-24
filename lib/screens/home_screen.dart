import 'dart:async';
import 'package:bachu/screens/friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Geolocator geolocator = Geolocator();
  final Completer<GoogleMapController> _controller = Completer();
  String? mapTheme;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late StreamSubscription<Position> _positionStreamSubscription;
  late Future<Map<String, dynamic>> _initialCameraPositionFuture;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Marker> _markers = <Marker>[];

  Future<void> getUserLocation() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .get();

    final double latitude = snapshot.get('latitude');
    final double longitude = snapshot.get('longitude');
    print('Coords: $latitude / $longitude');
  }

  Future<Map<String, dynamic>> getInitialCameraPosition() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .get();
    final double latitude = doc.get('latitude');
    final double longitude = doc.get('longitude');
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  void _removeMarkersWithTitle(String title) {
    setState(() {
      _markers.removeWhere((marker) => marker.infoWindow.title == title);
    });
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPositionFuture = getInitialCameraPosition();
    DefaultAssetBundle.of(context)
        .loadString('assets/themes/map/map_theme.json')
        .then((value) {
      mapTheme = value;
    });
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((position) async {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .doc('${FirebaseAuth.instance.currentUser!.email}')
          .get();

      final double latitude = snapshot.get('latitude');
      final double longitude = snapshot.get('longitude');
      setState(() {
        firestore
            .collection('users')
            .doc('${FirebaseAuth.instance.currentUser!.email}')
            .update({
              'latitude': position.latitude,
              'longitude': position.longitude,
            })
            .then((value) => print("Coords updated successfully"))
            .catchError((error) => print("Failed to update coords: $error"));
        _removeMarkersWithTitle("Моя локація");
        _markers.add(Marker(
          markerId: MarkerId('my_location'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: "Моя локація",
          ),
        ));
      });
      getUserLocation();
      print('${position.latitude} / ${position.longitude}');
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialCameraPositionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          // Here you can access the initial camera position from snapshot.data
          final initialCameraPosition = CameraPosition(
            target: LatLng(
              snapshot.data!['latitude'],
              snapshot.data!['longitude'],
            ),
            zoom: 14,
          );
          return Scaffold(
            floatingActionButton: Padding(
              padding: EdgeInsets.only(left: 75, right: 45, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton(
                      heroTag: 'friends',
                      backgroundColor: Colors.black,
                      elevation: 0,
                      onPressed: () {
                        Get.to(() => Friends(),
                            transition: Transition.downToUp);
                      },
                      child: Icon(Icons.people_alt, color: Colors.yellow)),
                  Spacer(),
                  FloatingActionButton(
                      heroTag: 'me',
                      backgroundColor: Colors.black,
                      elevation: 0,
                      onPressed: () async {
                        final DocumentSnapshot<
                            Map<String,
                                dynamic>> snapshot = await firestore
                            .collection('users')
                            .doc('${FirebaseAuth.instance.currentUser!.email}')
                            .get();
                        GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(snapshot.get('latitude'),
                              snapshot.get('longitude')),
                          zoom: 14,
                        )));
                        setState(() {});
                      },
                      child: Icon(Icons.location_on, color: Colors.yellow)),
                  Spacer(),
                  FloatingActionButton(
                      heroTag: 'profile',
                      backgroundColor: Colors.black,
                      elevation: 0,
                      onPressed: () {},
                      child: Icon(Icons.person, color: Colors.yellow)),
                ],
              ),
            ),
            body: SafeArea(
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: Set<Marker>.of(_markers),
                mapType: MapType.normal,
                myLocationEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(mapTheme);
                  _controller.complete(controller);
                },
              ),
            ),
          );
        });
  }
}
