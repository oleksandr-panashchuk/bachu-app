import 'package:bachu/screens/authScreens/buy_premium.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 9, 1),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc('${FirebaseAuth.instance.currentUser!.email}')
            .snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(
                  child: SpinKitThreeBounce(
                  color: Color.fromRGBO(195, 10, 154, 1),
                  size: 21,
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.data() as Map<String, dynamic>;

                    return Column(
                      children: [
                        SizedBox(
                          height: 52,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(195, 10, 154, 1)),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(Icons.arrow_back_sharp,
                                      color: Color.fromRGBO(195, 10, 154, 1)),
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(data['username'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(195, 10, 154, 1)),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(Icons.settings,
                                      color: Color.fromRGBO(195, 10, 154, 1)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${data['name'][0]}. ${data['surname']}',
                                      style: TextStyle(
                                          color: data['premium']
                                              ? Color.fromRGBO(255, 139, 19, 1)
                                              : Colors.white,
                                          fontSize: 23.5)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(data['email'],
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.45),
                                          fontSize: 14)),
                                ],
                              ),
                              Spacer(),
                              data['premium']
                                  ? Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 139, 19, 1),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 17,
                                                    color: Color.fromRGBO(
                                                        255, 139, 19, 0.71))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(21)),
                                          alignment: Alignment.center,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(21),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        '${FirebaseAuth.instance.currentUser!.photoURL}'),
                                                    fit: BoxFit.cover)),
                                            width: 77,
                                            height: 77,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 65,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 17,
                                                      color: Color.fromRGBO(
                                                          255, 139, 19, 0.71))
                                                ],
                                                color: Color.fromRGBO(
                                                    255, 139, 19, 1),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Icon(FontAwesomeIcons.crown,
                                                color: Colors.yellowAccent,
                                                size: 17),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${FirebaseAuth.instance.currentUser!.photoURL}'),
                                              fit: BoxFit.cover)),
                                      width: 77,
                                      height: 77,
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 21,
                        ),
                        data['premium']
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 21, vertical: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 21, vertical: 21),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(17)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Статус:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        )),
                                    Spacer(),
                                    Text('Преміум',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(255, 139, 59, 1),
                                            fontSize: 21,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 21, vertical: 5),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 21, vertical: 21),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(17)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Статус:',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            )),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text('Звичайний',
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.52),
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Get.to(() => BuyPremium(),
                                          transition: Transition.downToUp);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(21),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 21, vertical: 7),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(195, 10, 154, 1),
                                          borderRadius:
                                              BorderRadius.circular(17),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 12,
                                                offset: Offset(-2, 3),
                                                color: Color.fromRGBO(
                                                    195, 10, 154, 1))
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.card_giftcard_sharp,
                                              color: Colors.white),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text('Придбати преміум',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    );
                  });
        },
      ),
    );
  }
}
