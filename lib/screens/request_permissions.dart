import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissions extends StatefulWidget {
  const RequestPermissions({super.key});

  @override
  State<RequestPermissions> createState() => _RequestPermissionsState();
}

class _RequestPermissionsState extends State<RequestPermissions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Request Permission"),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                child: Text("Request Single Permission"),
                onPressed: () async {
                  if (await Permission.location.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    print("Location Permission is granted");
                  } else {
                    print("Location Permission is denied.");
                  }
                },
              ),
              ElevatedButton(
                child: Text("Request Multiple Permission"),
                onPressed: () async {
                  // You can request multiple permissions at once.
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.location,
                    Permission.camera,
                    //add more permission to request here.
                  ].request();

                  if (statuses[Permission.location]!.isDenied) {
                    //check each permission status after.
                    print("Location permission is denied.");
                  }

                  if (statuses[Permission.camera]!.isDenied) {
                    //check each permission status after.
                    print("Camera permission is denied.");
                  }
                },
              ),
              ElevatedButton(
                child: Text("Check Camera Permission"),
                onPressed: () async {
                  //check permission without request popup
                  var status = await Permission.camera.status;
                  if (status.isDenied) {
                    // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    print("Permission is denined.");
                  } else if (status.isGranted) {
                    //permission is already granted.
                    print("Permission is already granted.");
                  } else if (status.isPermanentlyDenied) {
                    //permission is permanently denied.
                    print("Permission is permanently denied");
                  } else if (status.isRestricted) {
                    //permission is OS restricted.
                    print("Permission is OS restricted.");
                  }
                },
              )
            ],
          ),
        ));
  }
}
