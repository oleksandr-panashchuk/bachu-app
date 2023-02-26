import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              ? Center(child: CircularProgressIndicator(color: Colors.yellow))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.data() as Map<String, dynamic>;
                    bool premium = true;
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
                                      border: Border.all(color: Colors.yellow),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(Icons.arrow_back_sharp,
                                      color: Colors.yellow),
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
                                      border: Border.all(color: Colors.yellow),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Icon(Icons.settings,
                                      color: Colors.yellow),
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
                              premium
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
                                                  BorderRadius.circular(17)),
                                          alignment: Alignment.center,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(17),
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
                                              BorderRadius.circular(17),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${FirebaseAuth.instance.currentUser!.photoURL}'),
                                              fit: BoxFit.cover)),
                                      width: 77,
                                      height: 77,
                                    ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${data['name']}\n${data['surname']}',
                                      style: TextStyle(
                                          color: premium
                                              ? Color.fromRGBO(255, 139, 19, 1)
                                              : Colors.white,
                                          fontSize: 22)),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(data['email'],
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.45),
                                          fontSize: 14))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
        },
      ),
    );
  }
}
