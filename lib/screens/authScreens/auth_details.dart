import 'dart:io';
import 'dart:ui';

import 'package:bachu/screens/authScreens/ban.dart';
import 'package:bachu/screens/authScreens/congrats.dart';
import 'package:bachu/screens/firebase_services.dart';
import 'package:bachu/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';

class AuthDetails extends StatefulWidget {
  const AuthDetails({super.key});

  @override
  State<AuthDetails> createState() => _AuthDetailsState();
}

class _AuthDetailsState extends State<AuthDetails> {
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController age = TextEditingController();
  double? latitude;
  double? longitude;

  final pageController = PageController();

  bool busy = false;
  bool nameCheck = false;
  bool batteryCheck = true;
  bool locationCheck = true;
  bool allGood = false;

  boolsCheck() async {
    if (locationCheck == false && batteryCheck == false) {
      setState(() {
        allGood = true;
      });
    }
  }

  bool usernameEmptyCheck = false;

  Future<bool> checkIfObjectExists(String searchObject) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await collectionReference.get();
    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final data = documentSnapshot.data();
        if (data is Map && data.containsValue(searchObject)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _checkIfObjectExists() async {
    bool exists = await checkIfObjectExists(username.text);
    setState(() {
      busy = exists;
    });
    if (exists) {
      return;
    }
    pageController.nextPage(
        duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    getPlatform();
    boolsCheck();
    super.initState();
  }

  double padding = 21;

  animOn() {
    setState(() {
      padding = 18;
    });
  }

  animOff() {
    setState(() {
      padding = 21;
    });
  }

  Future<String> getPlatformName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return 'Android';
    } else {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return 'iOS';
    }
  }

  getPlatform() async {
    final platform = await getPlatformName();
    if (platform == 'Android') {
      batteryCheck = true;
    }
    if (platform == 'iOS') {
      batteryCheck = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back1.png'), fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              RiveAnimation.asset('assets/background.riv'),
              Positioned.fill(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 450, sigmaY: 450),
                    child: SizedBox()),
              ),
              PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 77,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                        child: Text('Введи свій нікнейм',
                            style: TextStyle(
                                color: Color.fromRGBO(235, 15, 134, 1),
                                fontSize: 22,
                                fontWeight: FontWeight.w500)),
                      ),
                      Spacer(),
                      Center(
                        child: TextField(
                          controller: username,
                          textAlign: TextAlign.center,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9_.a-zA-Z]")),
                          ],
                          style: TextStyle(color: Colors.white, fontSize: 30),
                          decoration: InputDecoration(
                              hintText: 'поле вводу',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.21),
                                  fontSize: 30),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('Цей нікнейм вже зайнятий',
                            style: TextStyle(
                                color: busy ? Colors.red : Colors.transparent,
                                fontSize: 15)),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () async {
                            animOn();
                            await Future.delayed(Duration(milliseconds: 107));
                            animOff();
                            if (username.text.isNotEmpty) {
                              _checkIfObjectExists();
                            } else {
                              setState(() {
                                usernameEmptyCheck = false;
                              });
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 107),
                            padding: EdgeInsets.all(padding),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.05))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_right_alt,
                                    color: Colors.white, size: 30),
                                SizedBox(
                                  width: 7,
                                ),
                                Text('Продовжити',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 52,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: InkWell(
                          onTap: () {
                            pageController.previousPage(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeInOut);
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.05))),
                            child: Icon(Icons.arrow_back_sharp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                        child: Text('Твоє ім\'я',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text('Введи своє ім\'я та прізвище.',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.35),
                                fontSize: 17)),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(17)),
                        child: TextField(
                          controller: name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[а-яА-Я-a-zA-Z]")),
                          ],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: 'Твоє ім\'я',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.21),
                                  fontSize: 16),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                        margin: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(17)),
                        child: TextField(
                          controller: surname,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[а-яА-Я-a-zA-Z]")),
                          ],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: 'Твоє прізвище',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.21),
                                  fontSize: 16),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        child: Text('Перевір введені дані',
                            style: TextStyle(
                                color:
                                    nameCheck ? Colors.red : Colors.transparent,
                                fontSize: 13)),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () async {
                            animOn();
                            await Future.delayed(Duration(milliseconds: 107));
                            animOff();
                            if (name.text.length < 3) {
                              setState(() {
                                nameCheck = true;
                              });
                              return;
                            }
                            if (surname.text.length < 3) {
                              setState(() {
                                nameCheck = true;
                              });
                              return;
                            } else {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 107),
                            padding: EdgeInsets.all(padding),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.05))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_right_alt,
                                    color: Colors.white, size: 30),
                                SizedBox(
                                  width: 7,
                                ),
                                Text('Продовжити',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 52,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: InkWell(
                          onTap: () {
                            pageController.previousPage(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeInOut);
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(Icons.arrow_back_sharp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                        child: Text('Введи свій вік',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(17)),
                        child: TextField(
                          controller: age,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: 'Твій вік',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.21),
                                  fontSize: 16),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () async {
                            animOn();
                            await Future.delayed(Duration(milliseconds: 107));
                            animOff();
                            int ageI = int.parse(age.text);
                            if (ageI < 12) {
                              var db = FirebaseFirestore.instance
                                  .collection('ban-list');
                              db
                                  .doc(
                                      '${FirebaseAuth.instance.currentUser!.email}')
                                  .set({'banned': true});
                              // ignore: use_build_context_synchronously
                              Get.until((route) => false);
                              Get.to(() => Ban(), transition: Transition.zoom);
                            } else {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeInOut);
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 107),
                            padding: EdgeInsets.all(padding),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.05))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_right_alt,
                                    color: Colors.white, size: 30),
                                SizedBox(
                                  width: 7,
                                ),
                                Text('Продовжити',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 52,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: InkWell(
                          onTap: () {
                            pageController.previousPage(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeInOut);
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.yellow),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(Icons.arrow_back_sharp,
                                color: Colors.yellow),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text('Надай доступи для додатку',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                            'Ці всі доступи необхідні для\nфункціонування додатку.',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.35),
                                fontSize: 15)),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(17)),
                        child: Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.white.withOpacity(0.30),
                                size: 45),
                            SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Локація',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text('Надай додатку доступ\nдо геолокації.',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.30),
                                        fontSize: 14))
                              ],
                            ),
                            Spacer(),
                            IgnorePointer(
                              ignoring: locationCheck ? false : true,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  await Geolocator.requestPermission()
                                      .then((value) {})
                                      .onError((error, stackTrace) async {
                                    await Geolocator.requestPermission();
                                  });
                                  await Geolocator.getCurrentPosition();
                                  setState(() {
                                    locationCheck = false;
                                  });
                                  boolsCheck();
                                },
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: locationCheck
                                              ? Colors.yellow
                                              : Colors.white
                                                  .withOpacity(0.30))),
                                  child: Icon(
                                      locationCheck ? Icons.add : Icons.done,
                                      color: locationCheck
                                          ? Colors.yellow
                                          : Colors.white.withOpacity(0.30)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(17)),
                        child: Row(
                          children: [
                            Icon(Icons.battery_saver,
                                color: Colors.white.withOpacity(0.30),
                                size: 45),
                            SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Витрати батареї',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text('Вимкнення обмеження\nна витрати батареї.',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.30),
                                        fontSize: 14))
                              ],
                            ),
                            Spacer(),
                            IgnorePointer(
                              ignoring: batteryCheck ? false : true,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  OptimizeBattery
                                          .isIgnoringBatteryOptimizations()
                                      .then((onValue) {
                                    setState(() {
                                      if (onValue) {
                                        setState(() {
                                          batteryCheck = false;
                                        });
                                      } else {
                                        OptimizeBattery
                                            .stopOptimizingBatteryUsage();
                                      }
                                    });
                                  });
                                  setState(() {
                                    batteryCheck = false;
                                  });
                                  boolsCheck();
                                },
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: batteryCheck
                                              ? Colors.yellow
                                              : Colors.white
                                                  .withOpacity(0.30))),
                                  child: Icon(
                                      batteryCheck ? Icons.add : Icons.done,
                                      color: batteryCheck
                                          ? Colors.yellow
                                          : Colors.white.withOpacity(0.30)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: IgnorePointer(
                          ignoring: allGood ? false : true,
                          child: GestureDetector(
                            onTap: () async {
                              animOn();
                              await Future.delayed(Duration(milliseconds: 107));
                              animOff();
                              final position =
                                  await Geolocator.getCurrentPosition();
                              var db = FirebaseFirestore.instance
                                  .collection('users');
                              db
                                  .doc(
                                      '${FirebaseAuth.instance.currentUser!.email}')
                                  .set({
                                'username': username.text,
                                'name': name.text,
                                'surname': surname.text,
                                'latitude': position.latitude,
                                'longitude': position.longitude,
                                'age': age.text,
                                'photo':
                                    '${FirebaseAuth.instance.currentUser!.photoURL}',
                                'email':
                                    '${FirebaseAuth.instance.currentUser!.email}',
                                'premium': false,
                                'joinData':
                                    '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}'
                              });
                              Get.until((route) => false);
                              Get.to(() => Congrats(),
                                  transition: Transition.zoom);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 107),
                              padding: EdgeInsets.all(padding),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: allGood
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(17),
                                  border: allGood
                                      ? Border.all(
                                          color: Colors.white.withOpacity(0.05))
                                      : Border.all(color: Colors.transparent)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_right_alt,
                                      color: allGood
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.52),
                                      size: 30),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text('Продовжити',
                                      style: TextStyle(
                                          color: allGood
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.52),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
            ])));
  }
}
