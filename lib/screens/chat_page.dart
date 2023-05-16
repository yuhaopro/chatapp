import 'package:chatapp/screens/export_pages.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/chat_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/sp_helper.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.groupId}) : super(key: key);

  final String groupId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  late DocumentSnapshot groupInfo;
  late String groupName = "";
  late CollectionReference membersCollection;
  late Stream messageSnapshots;
  final TextEditingController _messageController = TextEditingController();
  String formattedTime = "";

  Future<DocumentSnapshot> getGroupInfo() async {
    return await databaseService.getGroupInfo(widget.groupId);
  }

  String getTime() {
    final now = DateTime.now();
    debugPrint('Date and Time: ${DateTime.now()}');
    final formatter = DateFormat('HH:mm a');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: FutureBuilder<DocumentSnapshot>(
          future: databaseService.getGroupInfo(widget.groupId),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppBar(
                backgroundColor: Colors.black87,
                centerTitle: true,
                title: const Text('Loading...'),
              );
            }

            if (snapshot.hasError) {
              return AppBar(
                backgroundColor: Colors.black87,
                centerTitle: true,
                title: const Text('Error'),
              );
            }

            groupName = snapshot.data!['groupName'];
            membersCollection = snapshot.data!.reference.collection('Members');

            return AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info,
                  ),
                ),
              ],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
              ),
              backgroundColor: Colors.black87,
              centerTitle: true,
              title: Text(
                groupName,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ChatBody(
              messageStream: databaseService.groupCollection
                  .doc(widget.groupId)
                  .collection("messages")
                  .orderBy("timeStamp")
                  .snapshots(),
              groupId: widget.groupId,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: null,
                  maxLength: 256,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _messageController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    labelText: "Enter Message..",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.black,
                  onPressed: () async {
                    // Send message
                    CollectionReference chatCollection = databaseService
                        .groupCollection
                        .doc(widget.groupId)
                        .collection('messages');
                    String message = _messageController.text;
                    String? messageSender = await SPHelper.getUsername();
                    String? messageSenderId =
                        FirebaseAuth.instance.currentUser!.uid;

                    // update the messages collection
                    await databaseService.updateChatMessage(chatCollection,
                        message, messageSender!, messageSenderId);

                    debugPrint("Sending Message...");
                    _messageController.clear();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
