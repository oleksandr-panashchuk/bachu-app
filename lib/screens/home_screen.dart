import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  String? mapTheme;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(50.618503037894925, 26.255840063614464),
    zoom: 14,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/themes/map/map_theme.json')
        .then((value) {
      mapTheme = value;
    });
  }

  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('2'),
        position: LatLng(50.607632800500355, 26.306087333248627),
        infoWindow:
            InfoWindow(title: 'Тест заголовку', snippet: 'Тест підзаголовку'),
        icon: BitmapDescriptor.defaultMarker),
  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String imageURL =
              "https://img.icons8.com/fluency/256/region-code.png";
          getUserCurrentLocation().then((value) async {
            Uint8List bytes =
                (await NetworkAssetBundle(Uri.parse(imageURL)).load(imageURL))
                    .buffer
                    .asUint8List();
            final coordinates = Coordinates(value.latitude, value.longitude);
            var adress =
                await Geocoder.local.findAddressesFromCoordinates(coordinates);
            _markers.add(Marker(
              markerId: const MarkerId("1"),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: InfoWindow(
                title: "Моя локація",
                snippet: adress.first.addressLine.toString(),
              ),
              icon: BitmapDescriptor.fromBytes(bytes),
            ));

            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
