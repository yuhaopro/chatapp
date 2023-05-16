import 'package:chatapp/models/group_data.dart';
import 'package:chatapp/screens/chat_page.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/services/sp_helper.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/add_user_tile.dart';

class AddUserToGroup extends StatefulWidget {
  const AddUserToGroup({Key? key}) : super(key: key);

  @override
  State<AddUserToGroup> createState() => _AddUserToGroupState();
}

class _AddUserToGroupState extends State<AddUserToGroup> {
  late DatabaseService databaseService;
  AuthService authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  String email = "";
  String username = "";
  Stream<QuerySnapshot>? _searchResults;
  final Color _iconColor = Colors.white;
  bool _isLoading = false;

  gettingUserData() async {
    await SPHelper.getEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await SPHelper.getUsername().then((value) {
      setState(() {
        username = value!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    databaseService =
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    debugPrint(databaseService.uid);
    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    final groupData = context.watch<GroupData>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          controller: _searchController,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            // by default there is some padding in the input decoration causing the text to be misaligned with the icon
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            labelText: "Add users..",
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Icon(
              Icons.search,
            ),
            prefixIconColor: Colors.white,
          ),
          onChanged: _usernameSearch,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          maxLines: 1,
        ),
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        username: username,
        authService: authService,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.black,
        onPressed: () async {
          List<String> usernames = groupData.getUsernames;
          String groupName = groupData.getGroupName;
          String groupId = await addGroupToDatabase(usernames, groupName);
          groupData.clearMembers();
          groupData.setGroupName("");
          // remove the previous pages until home page, then push the new chat group on top
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  groupId: groupId,
                ),
              ),
            );
          }
        },
        child: Center(
          child: Icon(
            Icons.arrow_forward_rounded,
            color: _iconColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer(
              builder: (context, groupData, child) {
                return AddUserTile(
                  searchResults: _searchResults,
                );
              },
            ),
    );
  }

  // search for username
  void _usernameSearch(String startingCharacters) {
    if (startingCharacters.isNotEmpty) {
      setState(() {
        _searchResults = databaseService.gettingUsernameCollection(
            startingCharacters, username);
      });
    } else {
      setState(() {
        _searchResults = null;
      });
    }
  }

  Future addGroupToDatabase(List<String> usernames, String groupName) async {
    setState(() {
      _isLoading = true;
    });
    // call database service
    return await databaseService
        .createGroupInfo(groupName)
        .then((documentReference) async {
      CollectionReference memberCollectionReference =
          documentReference.collection("Members");

      // Create batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (int i = 0; i < usernames.length; i++) {
        // get member UID
        String uid = await databaseService
            .gettingUserIdFromUsernamesCollection(usernames[i]);
        debugPrint("UID: $uid");

        // Update group members collection
        batch.set(memberCollectionReference.doc(uid),
            {"admin": false, "username": usernames[i], "acceptInvite": false});

        // Update the users invite field
        // Suggested to use server-side to conduct database updates
        await databaseService.updateUserGroupInvites(
            uid,
            groupName,
            documentReference.id,
            username,
            FirebaseAuth.instance.currentUser!.uid);
      }
      // wait for batch to finish committing
      await batch.commit();

      // set current user as member of group with admin
      memberCollectionReference.doc(databaseService.uid!).set({
        "admin": true,
        "username": username,
      });
      // update current user group field in users collection
      await databaseService.updateUserGroups(documentReference.id);

      // return the created groupId to be passed onto the groupChat
      return documentReference.id;
    });
  }
}
