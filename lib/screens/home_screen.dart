import 'dart:async';
import 'dart:developer';
import 'package:bachu/screens/friends.dart';
import 'package:bachu/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  late Future<Map<String, dynamic>> _initialCameraPositionFuture;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Marker> _markers = <Marker>[];

  Future<Map<String, dynamic>> getInitialCameraPosition() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .get();
    return {
      "latitude": doc.get('latitude'),
      "longitude": doc.get('longitude'),
    };
  }

  Future<void> getUsers() async {
    CollectionReference subSourceCollection = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('my_friends');
    QuerySnapshot subQuerySnapshot = await subSourceCollection.get();

    QuerySnapshot secondSubQuerySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in subQuerySnapshot.docs) {
      for (var secondDoc in secondSubQuerySnapshot.docs) {
        _markers.add(Marker(
          markerId: MarkerId('${doc['email']}'),
          position: LatLng(secondDoc['latitude'], secondDoc['longitude']),
          infoWindow: InfoWindow(
            title: "${doc['email']}",
          ),
        ));
      }
    }
  }

  void _removeMarkersWithTitle(String title) {
    setState(() {
      _markers.removeWhere((marker) => marker.infoWindow.title == title);
    });
  }

  shareLoc() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((position) async {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .doc('${FirebaseAuth.instance.currentUser!.email}')
          .get();

      final double latitude = snapshot.get('latitude');
      final double longitude = snapshot.get('longitude');
      CollectionReference subSourceCollection = FirebaseFirestore.instance
          .collection('users')
          .doc('${FirebaseAuth.instance.currentUser!.email}')
          .collection('my_friends');
      QuerySnapshot subQuerySnapshot = await subSourceCollection.get();

      CollectionReference secondSubSourceCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot secondSubQuerySnapshot =
          await secondSubSourceCollection.get();
      final url = '${FirebaseAuth.instance.currentUser!.photoURL}';
      final myImage = await NetworkAssetBundle(Uri.parse(url)).load('');
      setState(() {
        FirebaseFirestore.instance
            .collection('users')
            .doc('${FirebaseAuth.instance.currentUser!.email}')
            .update({
              'latitude': position.latitude,
              'longitude': position.longitude,
            })
            .then((value) => log("Coords updated successfully"))
            .catchError((error) => log("Failed to update coords: $error"));
        _removeMarkersWithTitle("${FirebaseAuth.instance.currentUser!.email}");
        _markers.add(Marker(
          onTap: () {
            log('Tapped');
          },
          markerId: MarkerId('${FirebaseAuth.instance.currentUser!.email}'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: "${FirebaseAuth.instance.currentUser!.email}",
          ),
          icon: BitmapDescriptor.fromBytes(myImage.buffer.asUint8List()),
        ));

        for (var doc in subQuerySnapshot.docs) {
          for (var secondDoc in secondSubQuerySnapshot.docs) {
            _removeMarkersWithTitle("${secondDoc['email']}");
            _markers.add(Marker(
              onTap: () {
                log('Tapped');
              },
              markerId: MarkerId('${secondDoc['email']}'),
              position: LatLng(secondDoc['latitude'], secondDoc['longitude']),
              infoWindow: InfoWindow(
                title: "${secondDoc['email']}",
              ),
            ));
          }
        }
      });
      log('${position.latitude} / ${position.longitude}');
    });
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPositionFuture = getInitialCameraPosition();
    countDocuments();
    DefaultAssetBundle.of(context)
        .loadString('assets/themes/map/map_theme.json')
        .then((value) {
      mapTheme = value;
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

  getMyLoc() async {
    animOn1();
    await Future.delayed(Duration(milliseconds: 107));
    animOff1();

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .get();
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(snapshot.get('latitude'), snapshot.get('longitude')),
      zoom: 16,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialCameraPositionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.yellow,
                size: 21,
              ),
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
          return Stack(alignment: Alignment.bottomCenter, children: [
            Scaffold(
              backgroundColor: Color.fromRGBO(18, 18, 18, 1),
              body: WillStartForegroundTask(
                onWillStart: () async {
                  shareLoc();
                  return true;
                },
                androidNotificationOptions: AndroidNotificationOptions(
                  channelId: 'notification_channel_id',
                  channelName: 'Foreground Notification',
                  channelDescription:
                      'This notification appears when the foreground service is running.',
                  channelImportance: NotificationChannelImportance.LOW,
                  priority: NotificationPriority.LOW,
                  iconData: const NotificationIconData(
                    resType: ResourceType.mipmap,
                    resPrefix: ResourcePrefix.ic,
                    name: 'launcher',
                  ),
                  buttons: [
                    const NotificationButton(id: 'sendButton', text: 'Send'),
                    const NotificationButton(id: 'testButton', text: 'Test'),
                  ],
                ),
                iosNotificationOptions: const IOSNotificationOptions(
                  showNotification: true,
                  playSound: false,
                ),
                foregroundTaskOptions: const ForegroundTaskOptions(
                  isOnceEvent: false,
                  autoRunOnBoot: true,
                  allowWakeLock: true,
                  allowWifiLock: true,
                ),
                notificationTitle: 'Bachu is running in foreground.',
                notificationText: 'Tap to return to the app.',
                child: SafeArea(
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 45),
              child: Stack(alignment: Alignment.topCenter, children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 52),
                  margin: EdgeInsets.all(12),
                  width: double.infinity,
                  height: 77,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white.withOpacity(0.07)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.to(() => Friends(),
                                transition: Transition.downToUp);
                          },
                          child: Icon(Icons.people, color: Colors.white)),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => Profile(),
                                transition: Transition.downToUp);
                          },
                          child: Icon(Icons.person, color: Colors.white))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getMyLoc();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 107),
                    width: width1,
                    height: width1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(98, 14, 125, 1),
                              Color.fromRGBO(195, 10, 154, 1)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(150),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 21,
                            offset: Offset(0, 3),
                            color: Color.fromRGBO(171, 14, 154, 0.52),
                          )
                        ]),
                    child:
                        Icon(Icons.location_on, color: Colors.white, size: 30),
                  ),
                ),
              ]),
            ),
          ]);
        });
  }
}
