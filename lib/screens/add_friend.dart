import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController friend = TextEditingController();

  bool reged = true;

  Future<bool> checkIfDocumentExists(
      String collectionName, String documentId) async {
    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .get();

    return document.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 3, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 77,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Text('Додати друга',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text('З друзями кращу, ніж без них.',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.35), fontSize: 17)),
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
                    if (friend.text.isEmpty) {
                      setState(() {
                        reged = true;
                      });
                      return;
                    }
                    if (friend.text.isNotEmpty) {
                      bool exists =
                          await checkIfDocumentExists('users', friend.text);
                      setState(() {
                        reged = exists;
                      });
                      if (exists == true) {
                        var myFriends = FirebaseFirestore.instance
                            .collection('users')
                            .doc('${FirebaseAuth.instance.currentUser!.email}')
                            .collection(
                                '${FirebaseAuth.instance.currentUser!.email}_friends');
                        var amtFriend = FirebaseFirestore.instance
                            .collection('users')
                            .doc(friend.text)
                            .collection('${friend.text}_friends');
                        amtFriend
                            .doc('${FirebaseAuth.instance.currentUser!.email}')
                            .set({'friend': 'yes'}, SetOptions(merge: true));
                        myFriends
                            .doc(friend.text)
                            .set({'friend': 'yes'}, SetOptions(merge: true));
                      }
                      if (exists == false) {
                        return;
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
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
        ],
      ),
    );
  }
}
