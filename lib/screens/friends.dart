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
      .collection('${FirebaseAuth.instance.currentUser!.email}_friends')
      .snapshots();

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
                            fontSize: 17)),
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
          // StreamBuilder<QuerySnapshot>(
          //   stream: friends,
          //   builder: (context, snapshots) {
          //     return (snapshots.connectionState == ConnectionState.waiting)
          //         ? Center(
          //             child: CircularProgressIndicator(color: Colors.yellow))
          //         : ListView.builder(
          //             shrinkWrap: true,
          //             physics: BouncingScrollPhysics(),
          //             itemCount: snapshots.data!.docs.length,
          //             itemBuilder: (context, index) {
          //               var data = snapshots.data!.docs[index].data()
          //                   as Map<String, dynamic>;
          //               return Container(
          //                 padding: EdgeInsets.all(17),
          //                 decoration: BoxDecoration(
          //                     color: Colors.white.withOpacity(0.07),
          //                     borderRadius: BorderRadius.circular(17)),
          //                 child: Row(
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('${data['name']} ${data['surname']}',
          //                             style: TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: 21,
          //                                 fontWeight: FontWeight.w500)),
          //                         SizedBox(
          //                           height: 5,
          //                         ),
          //                         Text(data['username'],
          //                             style: TextStyle(
          //                                 color: Colors.white.withOpacity(0.52),
          //                                 fontSize: 16))
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //               );
          //             });
          //   },
          // ),
        ],
      ),
    );
  }
}
