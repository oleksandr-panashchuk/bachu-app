import 'dart:ui';

import 'package:bachu/screens/authScreens/auth_details.dart';
import 'package:bachu/screens/authScreens/ban.dart';
import 'package:bachu/screens/firebase_services.dart';
import 'package:bachu/screens/friends.dart';
import 'package:bachu/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(6, 0, 9, 1),
        body: Stack(children: [
          RiveAnimation.asset('assets/background.riv'),
          Positioned.fill(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 450, sigmaY: 450),
                child: SizedBox()),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 77,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
              child: Text('Авторизація',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text('Вхід/Реєстрація в Bachu.',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35), fontSize: 17)),
            ),
            SizedBox(
              height: 87,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 350,
                child: RiveAnimation.asset(
                  'assets/back.riv',
                ),
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
                  await FirebaseServices().signInWithGoogle();
                  Future<bool> checkIfDocumentExists(
                      String collectionName, String documentId) async {
                    final DocumentSnapshot document = await FirebaseFirestore
                        .instance
                        .collection(collectionName)
                        .doc(documentId)
                        .get();

                    return document.exists;
                  }

                  bool exists = await checkIfDocumentExists(
                      'users', '${FirebaseAuth.instance.currentUser!.email}');
                  bool banned = await checkIfDocumentExists('ban-list',
                      '${FirebaseAuth.instance.currentUser!.email}');

                  if (banned == true) {
                    // ignore: use_build_context_synchronously
                    Get.until((route) => false);
                    Get.to(() => Ban(), transition: Transition.leftToRight);
                  }
                  if (banned == false) {
                    if (exists == true) {
                      // ignore: use_build_context_synchronously
                      Get.until((route) => false);
                      Get.to(() => HomeScreen(),
                          transition: Transition.leftToRight);
                    }
                    if (exists == false) {
                      // ignore: use_build_context_synchronously
                      Get.until((route) => false);
                      Get.to(() => AuthDetails(),
                          transition: Transition.leftToRight);
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 107),
                  padding: EdgeInsets.all(padding),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(17),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.05))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google,
                          size: 17, color: Colors.white),
                      SizedBox(
                        width: 7,
                      ),
                      Text('Увійти через Google',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ]),
        ]));
  }
}
