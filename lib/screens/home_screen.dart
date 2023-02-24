import 'dart:async';
import 'package:bachu/screens/friends.dart';
import 'package:bachu/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Geolocator geolocator = Geolocator();
  final Completer<GoogleMapController> _controller = Completer();
  String? mapTheme;

  late StreamSubscription<Position> _positionStreamSubscription;
  double latitudes = 50.618503037894925;
  double longitudes = 26.255840063614464;

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/themes/map/map_theme.json')
        .then((value) {
      mapTheme = value;
    });
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((position) {
      setState(() {
        latitudes = position.latitude;
        longitudes = position.longitude;
        _removeMarkersWithTitle("Моя локація");
        _markers.add(Marker(
          markerId:
              MarkerId('${Timestamp.now().microsecondsSinceEpoch}_my_location'),
          position: LatLng(latitudes, longitudes),
          infoWindow: InfoWindow(
            title: "Моя локація",
          ),
        ));
      });
      print('${position.latitude} / ${position.longitude}');
    });
  }

  final List<Marker> _markers = <Marker>[];

  void _removeMarkersWithTitle(String title) {
    setState(() {
      _markers.removeWhere((marker) => marker.infoWindow.title == title);
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 75, right: 45, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(() => Friends(), transition: Transition.downToUp);
              },
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 17,
                          offset: Offset(-1, 2),
                          color: Colors.yellow.withOpacity(0.07))
                    ]),
                child: Icon(Icons.people_alt, color: Colors.yellow),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.to(() => Friends(), transition: Transition.downToUp);
              },
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 17,
                          offset: Offset(-1, 2),
                          color: Colors.yellow.withOpacity(0.07))
                    ]),
                child: Icon(Icons.location_on, color: Colors.yellow),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.to(() => Profile(), transition: Transition.downToUp);
              },
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 17,
                          offset: Offset(-1, 2),
                          color: Colors.yellow.withOpacity(0.07))
                    ]),
                child: Icon(Icons.person, color: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(latitudes, longitudes),
            zoom: 14,
          ),
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
  }
}
