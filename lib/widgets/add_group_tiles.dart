import 'package:chatapp/screens/chat_page.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddGroupTiles extends StatefulWidget {
  const AddGroupTiles({Key? key, required this.userDocumentStreams})
      : super(key: key);
  final List<Stream<DocumentSnapshot>> userDocumentStreams;

  @override
  State<AddGroupTiles> createState() => _AddGroupTilesState();
}

class _AddGroupTilesState extends State<AddGroupTiles> {
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.userDocumentStreams.length,
      itemBuilder: (context, index) {
        // Get a groupsId corresponding to index
        return StreamBuilder<DocumentSnapshot>(
          stream: widget.userDocumentStreams[index],
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // snapshot received an error
            if (snapshots.hasError) {
              return Center(
                child: Text(
                  snapshots.error.toString(),
                ),
              );
            }

            if (!snapshots.hasData) {
              return const SizedBox.shrink();
            }

            // get DocumentSnapshot
            DocumentSnapshot documentSnapshot = snapshots.data!;

            // Get groupId, groupName, groupIcon, mostRecentMessage, mostRecentMessageSender
            String groupId = documentSnapshot.id;
            String groupName = documentSnapshot.get("groupName");
            String groupIcon = documentSnapshot.get("groupIcon");
            String mostRecentMessage =
                documentSnapshot.get("mostRecentMessage");
            String mostRecentMessageSender =
                documentSnapshot.get("mostRecentSender");

            return Column(
              children: [
                ListTile(
                  title: Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        mostRecentMessageSender == ""
                            ? ""
                            : '$mostRecentMessageSender: ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Expanded(
                        child: Text(
                          mostRecentMessage,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // go to the group chat page.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(groupId: groupId)),
                    );
                  },
                ),
                const Divider(
                  height: 1,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
