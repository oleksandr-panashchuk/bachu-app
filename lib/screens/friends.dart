import 'package:bachu/screens/add_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> friends = FirebaseFirestore
      .instance
      .collection('users')
      .doc('${FirebaseAuth.instance.currentUser!.email}')
      .collection('my_friends')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 3, 1),
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
                    Text('Мої друзі',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Чим більше - тим краще.',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 16)),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(() => AddFriend(), transition: Transition.downToUp);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15)),
                    child: Icon(Icons.add, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: friends,
            builder: (context, snapshots) {
              return (snapshots.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.yellow))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 21, vertical: 5),
                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(17)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  image: DecorationImage(
                                      image: NetworkImage(data['photo']),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${data['name']}\n${data['surname']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(data['username'],
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.45),
                                          fontSize: 15)),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.email}')
                                      .collection('my_friends')
                                      .doc(data['email'])
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(data['email'])
                                      .collection('my_friends')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.email}')
                                      .delete();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.yellow)),
                                  child: Icon(Icons.cancel_outlined,
                                      color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
            },
          ),
        ],
      ),
    );
  }
}
