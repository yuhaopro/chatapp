import 'package:chatapp/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupInvitesPage extends StatefulWidget {
  const GroupInvitesPage({Key? key}) : super(key: key);

  @override
  State<GroupInvitesPage> createState() => _GroupInvitesPageState();
}

class _GroupInvitesPageState extends State<GroupInvitesPage> {
  final DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  late final Stream<QuerySnapshot> groupInvites;
  @override
  void initState() {
    super.initState();
    groupInvites = databaseService.getGroupInvites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "Group Invites",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: groupInvites,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshots.hasError) {
              return Text("Error: ${snapshots.error}");
            }

            // ready to receive groupInvites snapshots.
            return ListView.builder(
                itemCount: snapshots.data!.size,
                itemBuilder: (context, index) {
                  // get the individual documents sorted by time
                  QueryDocumentSnapshot documentSnapshot =
                      snapshots.data!.docs[index];
                  // get group Name
                  String groupName = documentSnapshot.get("groupName");
                  // get Sender Name
                  String groupSender = documentSnapshot.get("groupSender");
                  // get timeStamp
                  Timestamp? timestamp = documentSnapshot.get("timeStamp");
                  String date = "";
                  String time = "";
                  if (timestamp == null) {
                    date = "";
                    time = "";
                  } else {
                    DateTime dateTime = timestamp.toDate();
                    time = DateFormat("HH:mm a").format(dateTime);
                    date = DateFormat("dd MM yyyy").format(dateTime);
                  }
                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  groupName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Sender: ",
                                          ),
                                          TextSpan(
                                            text: groupSender,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              // remove from groupInvites
                              await databaseService
                                  .removeGroupInvite(documentSnapshot.id);
                            },
                            icon: const Icon(Icons.cancel),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () async {
                              // remove from groupInvites
                              await databaseService
                                  .removeGroupInvite(documentSnapshot.id);
                              // add to group
                              await databaseService
                                  .updateUserGroups(documentSnapshot.id);
                            },
                            icon: const Icon(Icons.check_circle),
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ],
                      ),
                      const Divider(
                        height: 2,
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
