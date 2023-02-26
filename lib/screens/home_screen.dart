import 'dart:async';
import 'package:bachu/screens/friends.dart';
import 'package:bachu/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

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

  Future<void> getUsers() async {
    String imageURL = 'https://ibb.co/RzzHDvD';
    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(imageURL)).load(imageURL))
            .buffer
            .asUint8List();
    CollectionReference subSourceCollection = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('my_friends');
    QuerySnapshot subQuerySnapshot = await subSourceCollection.get();

    for (var doc in subQuerySnapshot.docs) {
      _markers.add(Marker(
        markerId: MarkerId('my_location'),
        position: LatLng(doc['latitude'], doc['longitude']),
        infoWindow: InfoWindow(
          title: "${doc['email']}",
        ),
      ));
      print('${doc['email']} | ${doc['latitude']} ${doc['longitude']}');
    }
  }

  void _removeMarkersWithTitle(String title) {
    setState(() {
      _markers.removeWhere((marker) => marker.infoWindow.title == title);
    });
  }

  shareLoc() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    // Отримання всіх документів з колекції users, що містять колекцію my_friends
    final documentsSnapshot = await userCollection
        .where('my_friends.$currentUserEmail', isEqualTo: true)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    documentsSnapshot.docs.forEach((doc) {
      final myFriendsDocRef =
          doc.reference.collection('my_friends').doc(currentUserEmail);
      batch.set(myFriendsDocRef, doc.data());
    });

    await batch.commit();
  }

  @override
  void initState() {
    countDocuments();
    super.initState();
    getUsers();
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
        // CollectionReference subSourceCollection = FirebaseFirestore.instance
        //     .collection('users')
        //     .doc('${FirebaseAuth.instance.currentUser!.email}')
        //     .collection('my_friends');
        // QuerySnapshot subQuerySnapshot = await subSourceCollection.get();

        // for (var doc in subQuerySnapshot.docs) {
        //   _removeMarkersWithTitle("${doc['email']}");
        //   _markers.add(Marker(
        //     markerId: MarkerId('my_location'),
        //     position: LatLng(doc['latitude'], doc['longitude']),
        //     infoWindow: InfoWindow(
        //       title: "${doc['email']}",
        //     ),
        //   ));
        //   print('${doc['email']} | ${doc['latitude']} ${doc['longitude']}');
        // }

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
    shareLoc();
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  bool reqs = false;

  int count = 0;

  void countDocuments() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('friend_requests');

    collectionReference.snapshots().listen((querySnapshot) {
      int count = querySnapshot.size;
      if (count > 0) {
        setState(() {
          reqs = true;
        });
      }
      if (count == 0) {
        setState(() {
          reqs = false;
        });
      }
    });
  }

  double width = 65;
  double height = 65;
  double width1 = 65;
  double height1 = 65;
  double width2 = 65;
  double height2 = 65;

  animOn() {
    setState(() {
      width = 58;
      height = 58;
    });
  }

  animOff() {
    setState(() {
      width = 65;
      height = 65;
    });
  }

  animOn1() {
    setState(() {
      width1 = 58;
      height1 = 58;
    });
  }

  animOff1() {
    setState(() {
      width1 = 65;
      height1 = 65;
    });
  }

  animOn2() {
    setState(() {
      width2 = 58;
      height2 = 58;
    });
  }

  animOff2() {
    setState(() {
      width2 = 65;
      height2 = 65;
    });
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
            zoom: 16,
          );
          return Scaffold(
            backgroundColor: Color.fromRGBO(18, 18, 18, 1),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(left: 75, right: 45, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      animOn();
                      await Future.delayed(Duration(milliseconds: 107));
                      animOff();
                      Get.to(() => Friends(), transition: Transition.downToUp);
                    },
                    borderRadius: BorderRadius.circular(17),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 107),
                      width: width,
                      height: height,
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
                    onTap: () async {
                      animOn1();
                      await Future.delayed(Duration(milliseconds: 107));
                      animOff1();

                      final DocumentSnapshot<Map<String, dynamic>> snapshot =
                          await firestore
                              .collection('users')
                              .doc(
                                  '${FirebaseAuth.instance.currentUser!.email}')
                              .get();
                      GoogleMapController controller = await _controller.future;
                      controller.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(snapshot.get('latitude'),
                            snapshot.get('longitude')),
                        zoom: 16,
                      )));
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(17),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 107),
                      width: width1,
                      height: height1,
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
                    onTap: () async {
                      animOn2();
                      await Future.delayed(Duration(milliseconds: 107));
                      animOff2();
                      Get.to(() => Profile(), transition: Transition.downToUp);
                    },
                    borderRadius: BorderRadius.circular(17),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 107),
                      width: width2,
                      height: height2,
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
