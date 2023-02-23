import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> friend_requests =
      FirebaseFirestore.instance
          .collection('users')
          .doc('${FirebaseAuth.instance.currentUser!.email}')
          .collection('friend_requests')
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 3, 3, 1),
      body: Column(
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
                    Text('Твої запроси',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Люди, які хочуть з тобою дружити.',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 15)),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: friend_requests,
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
                                  Text('${data['name']} ${data['surname']}',
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
                                      .collection('friend_requests')
                                      .doc(data['email'])
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
                              SizedBox(
                                width: 7,
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () async {
                                  CollectionReference sourceCollection =
                                      FirebaseFirestore.instance
                                          .collection('users');
                                  CollectionReference targetCollection =
                                      FirebaseFirestore.instance
                                          .collection('users');
                                  DocumentReference sourceDoc =
                                      sourceCollection.doc(data['email']);
                                  DocumentReference myDoc = sourceCollection.doc(
                                      '${FirebaseAuth.instance.currentUser!.email}');
                                  DocumentReference friendDoc = sourceCollection
                                      .doc(data['email'])
                                      .collection('my_friends')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.email}');
                                  DocumentReference targetDoc = targetCollection
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.email}')
                                      .collection('my_friends')
                                      .doc(data['email']);
                                  DocumentSnapshot sourceSnapshot =
                                      await sourceDoc.get();
                                  Map<String, dynamic> sourceData =
                                      sourceSnapshot.data()
                                          as Map<String, dynamic>;
                                  DocumentSnapshot mySnapshot =
                                      await myDoc.get();
                                  Map<String, dynamic> myData =
                                      mySnapshot.data() as Map<String, dynamic>;
                                  await targetDoc.set(sourceData);
                                  await friendDoc.set(myData);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser!.email}')
                                      .collection('friend_requests')
                                      .doc(data['email'])
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
                                  child: Icon(Icons.done, color: Colors.yellow),
                                ),
                              )
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
