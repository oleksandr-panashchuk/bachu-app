import 'package:bachu/screens/friend_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController friend = TextEditingController();

  bool reged = true;

  bool accept = false;

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

  Future<dynamic> getFieldBySearchValue(String collectionPath,
      String searchField, dynamic value, String field) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .where(searchField, isEqualTo: value)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final docData = snapshot.docs.first.data();
      return docData[field];
    } else {
      return null;
    }
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool reqs = false;

  int count = 0;

  void countDocuments() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('friend_requests');

    collectionReference.snapshots().listen((querySnapshot) {
      setState(() {
        count = querySnapshot.size;
      });
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

  int friends = 0;

  void countFriends() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('my_friends');

    collectionReference.snapshots().listen((querySnapshot) {
      setState(() {
        friends = querySnapshot.size;
      });
    });
  }

  @override
  void initState() {
    countDocuments();
    super.initState();
  }

  double padding = 15;

  animOn() {
    setState(() {
      padding = 12;
    });
  }

  animOff() {
    setState(() {
      padding = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 12, 9, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 52,
          ),
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
                child: Icon(Icons.arrow_back_sharp, color: Colors.yellow),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Запроси друга',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.5,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('З друзями краще, ніж без них.',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 14)),
                  ],
                ),
                Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Get.to(() => FriendRequests(),
                        transition: Transition.upToDown);
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.yellow)),
                        child: Icon(Icons.people, color: Colors.yellow),
                      ),
                      reqs
                          ? Container(
                              width: 17,
                              height: 17,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        offset: Offset(-2, -2),
                                        color: Colors.red.withOpacity(0.58))
                                  ],
                                  borderRadius: BorderRadius.circular(150)),
                              child: Text(count.toString(),
                                  style: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500)),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            padding: EdgeInsets.only(left: 17, right: 7, top: 7, bottom: 7),
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(17)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: friend,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                        hintText: 'E-mail друга',
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.21),
                            fontSize: 16),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    animOn();
                    await Future.delayed(Duration(milliseconds: 90));
                    animOff();
                    if (friend.text.isEmpty) {
                      setState(() {
                        reged = true;
                      });
                      return;
                    }
                    if (friend.text.isNotEmpty) {
                      bool exists = await checkIfObjectExists(friend.text);
                      setState(() {
                        reged = exists;
                      });
                      if (exists == true) {
                        final friendDoc = await getFieldBySearchValue(
                            'users', 'username', friend.text, 'email');
                        CollectionReference sourceCollection =
                            FirebaseFirestore.instance.collection('users');
                        CollectionReference targetCollection =
                            FirebaseFirestore.instance.collection('users');
                        DocumentReference sourceDoc = sourceCollection
                            .doc('${FirebaseAuth.instance.currentUser!.email}');
                        DocumentReference targetDoc = targetCollection
                            .doc(friendDoc)
                            .collection('friend_requests')
                            .doc('${FirebaseAuth.instance.currentUser!.email}');
                        DocumentSnapshot sourceSnapshot = await sourceDoc.get();
                        Map<String, dynamic> sourceData =
                            sourceSnapshot.data() as Map<String, dynamic>;
                        await targetDoc.set(sourceData);
                        countFriends();
                        targetDoc.update({'friends': friends});
                        setState(() {
                          accept = true;
                        });
                      }
                      if (exists == false) {
                        return;
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 90),
                    padding: EdgeInsets.all(padding),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 17,
                              offset: Offset(-2, 2),
                              color: Colors.yellow.withOpacity(0.25))
                        ],
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15)),
                    child: Icon(Icons.add, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text('Цей користувач не зареєстрований.',
                style: TextStyle(
                    color: reged ? Colors.transparent : Colors.red,
                    fontSize: 13)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            child: Text('Запрос було надіслано.',
                style: TextStyle(
                    color: accept
                        ? Color.fromRGBO(3, 201, 136, 1)
                        : Colors.transparent,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
