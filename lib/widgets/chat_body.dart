import 'package:chatapp/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/sp_helper.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({Key? key, required this.messageStream, required this.groupId})
      : super(key: key);

  final Stream<QuerySnapshot> messageStream;
  final String groupId;
  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  final ScrollController _scrollController = ScrollController();

  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void updateGroupRecentMessage(
      String message, String messageSender, String mostRecentSenderId) async {
    await databaseService.groupCollection.doc(widget.groupId).update({
      "mostRecentMessage": message,
      "mostRecentSender": messageSender,
      "mostRecentSenderId": mostRecentSenderId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SPHelper.getUsername(),
        builder: (context, AsyncSnapshot<String?> username) {
          if (username.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (username.hasError) {
            return Center(
              child: Text(
                username.error.toString(),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
              stream: widget.messageStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => scrollToEnd());
                  debugPrint("Displaying new message...");
                  return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        // current document inside chat collection
                        DocumentSnapshot documentSnapshot = documents[index];
                        DocumentSnapshot? previousDocumentSnapshot;
                        bool displayDate = false;
                        String previousDate = "";
                        if (index == 0) {
                          displayDate = true;
                          previousDocumentSnapshot = null;
                        } else {
                          previousDocumentSnapshot = documents[index - 1];
                          // get the previous date
                          Timestamp? previousTimestamp =
                              previousDocumentSnapshot.get("timeStamp");
                          if (previousTimestamp != null) {
                            DateTime previousDateTime =
                                previousTimestamp.toDate();
                            previousDate = DateFormat("dd MM yyyy")
                                .format(previousDateTime);
                          } else {
                            previousDate = "";
                          }
                        }

                        // get the message, messageSender, timestamp
                        String message = documentSnapshot.get("message");
                        String messageSender =
                            documentSnapshot.get("messageSender");
                        // get the timestamp once the server timestamp has been updated in firestore.
                        Timestamp? timestamp =
                            documentSnapshot.get("timeStamp");
                        DateTime dateTime;
                        String timeOnly;
                        String dateOnly;
                        if (timestamp == null) {
                          timeOnly = "";
                          dateOnly = "";
                        } else {
                          dateTime = timestamp.toDate();
                          timeOnly = DateFormat("HH:mm a").format(dateTime);
                          dateOnly = DateFormat("dd MM yyyy").format(dateTime);
                          // if date has changed compared to previous message
                          if (dateOnly != previousDate) {
                            displayDate = true;
                          }
                        }

                        String messageSenderId =
                            documentSnapshot.get("messageSenderId");
                        // check if messageSender is user
                        bool isMessageSenderOwner =
                            (messageSender == (username.data ?? ''));

                        // check if last line of message is empty
                        List<String> messageLines = message.split('\n');
                        messageLines.removeWhere((line) => line.trim().isEmpty);
                        String formattedMessage = messageLines.join(" ");

                        // check if this is the most recent message, to update groups collection
                        if (index == snapshot.data!.size - 1) {
                          // async function to update groups collection
                          updateGroupRecentMessage(
                              formattedMessage, messageSender, messageSenderId);
                        }
                        return Column(
                          children: [
                            if (displayDate)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isMessageSenderOwner
                                      ? Colors.blue[100]
                                      : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    dateOnly,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            Align(
                              alignment: isMessageSenderOwner
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isMessageSenderOwner
                                      ? Colors.blue[100]
                                      : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IntrinsicWidth(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messageSender,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              formattedMessage,
                                              maxLines: null,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              timeOnly,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  return const SizedBox.shrink();
                }
              });
        });
  }
}
