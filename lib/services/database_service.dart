import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  String? uid;
  DatabaseService({this.uid});

  // reference for Collection/Table
  CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  CollectionReference usernameCollection = FirebaseFirestore.instance.collection("usernames");
  CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  //saving the userdata into userCollection
  Future updateUserData(String username, String email) async {
    await userCollection.doc(uid).set({
      "username": username,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });

    await usernameCollection.doc(username).set({
      "uid": uid,
      "username": username,
    });
  }

  Future updateUserGroupInvites(String userId, String groupName, String groupId, String groupSenderName, String groupSenderId, ) async {
    // create new subcollection to store group invites
    CollectionReference groupInviteCollection = userCollection.doc(userId).collection("groupInvites");
    await groupInviteCollection.doc(groupId).set({
      "groupName": groupName,
      "groupId": groupId,
      "groupSender": groupSenderName,
      "groupSenderId": groupSenderId,
    });
  }

  Future updateUserGroups(String groupId, String userId) async {
    await userCollection.doc(userId).update({
      "groups": FieldValue.arrayUnion([groupId]),
    });
  }
  
  Future createGroupInfo(String groupName) async {

    // create new Document if group does not exist
    DocumentReference newDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupId": "",
      "groupIcon": "",
      "mostRecentMessage": "",
      "mostRecentSender": "",
      "mostRecentSenderId": "",
    });
    newDocumentReference.update({
      "groupId": newDocumentReference.id,
    });

    return newDocumentReference;

  }

  Future<DocumentSnapshot> getGroupInfo(String groupId) async {
    return await groupCollection.doc(groupId).get();
  }

  Future updateGroupIcon(String groupIcon, String groupId) async {
      await groupCollection.doc(groupId).update({
      "groupIcon": groupIcon,
   });
  }

  Future updateMostRecentMessage(String message, String groupId) async {
    await groupCollection.doc(groupId).update({
      "mostRecentMessage": message,
    });
  }

  Future updateMostRecentSender(String senderUsername, String groupId) async {
    await groupCollection.doc(groupId).update({
      "mostRecentSender": senderUsername,
    });
  }
  Future updateMostRecentSenderId(String senderId, String groupId) async {
    await groupCollection.doc(groupId).update({
      "mostRecentSenderId": senderId,
    });
  }

  Future updateChatMessage(CollectionReference chatCollection, String message, String messageSender, String messageSenderId, String timeStamp) async{
    // Update Chat collection fields
    DocumentReference documentReference = await chatCollection.add({
      "message": message,
      "timeStamp": timeStamp,
      "messageSender": messageSender,
      "messageSenderId": messageSenderId,
      "messageId": "",
    });
    // set the created DocumentId as the messageId
    await documentReference.update({
      "messageId": documentReference.id,
    });
  }

  Future updateGroupMembers(CollectionReference membersCollection, bool admin, String uid, String username) async{
    // Update Chat collection fields
    debugPrint("Setting members Collection with new document and field...");
    await membersCollection.doc(uid).set({
      "admin": admin,
      // true for accepted invites
      "inviteStatus": false,
      "username": username,
    });

  }
  
  Future<bool> checkDocumentExists(CollectionReference collectionReference, String documentId) async {

    try {
      DocumentSnapshot snapshot = await collectionReference.doc(documentId)
          .get();
      return snapshot.exists;
    } catch(e) {
      debugPrint("Document does not exist!");
      return false;
    }

  }
  // getting user data with email check
  Future gettingUserDataThroughEmail(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
  // getting userId from usernames collection
  Future gettingUserIdFromUsernamesCollection(String username) async {
    DocumentSnapshot documentSnapshot = await usernameCollection.doc(username).get();
    if (documentSnapshot.exists) {
      return documentSnapshot.get("uid");
    }
    debugPrint("No such username added...");
    return null;
  }

  Stream<QuerySnapshot> gettingUsernameCollection(String startingCharacters, String username) {
    return FirebaseFirestore.instance
        .collection('usernames')
        .where('username', isGreaterThanOrEqualTo: startingCharacters)
        // the \uf8ff notation is a very large unicode character which ensures that only usernames starting with the starting characters will return.
        .where('username', isLessThan: '$startingCharacters\uf8ff')
        .where('username', isNotEqualTo: username)
        .snapshots();
  }
}
