import 'package:chatapp/models/group_data.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/add_group_tiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:chatapp/services/sp_helper.dart';
import 'package:chatapp/widgets/drawer.dart';
import 'export_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  String username = "";
  String email = "";
  final TextEditingController _createGroupController = TextEditingController();

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

  Future<QuerySnapshot> gettingGroupDocuments() async {
    return await databaseService.groupCollection.get();
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    final groupData = context.watch<GroupData>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.search);
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "Chats",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        username: username,
        authService: authService,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: gettingGroupDocuments(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // getting snapshot
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // snapshot received an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          // snapshot data received
          return AddGroupTiles(groupsSnapshot: snapshot.data!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    "Enter group name",
                  ),
                  content: TextField(
                    controller: _createGroupController,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        size: 25,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        //Brings user to new screen to add group members
                        //Add group name to the GroupData model
                        groupData.setGroupName(_createGroupController.text);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddUserToGroup()));
                      },
                      icon: const Icon(
                        Icons.check_circle,
                        size: 25,
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
