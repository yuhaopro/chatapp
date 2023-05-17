import 'dart:io';

import 'package:chatapp/screens/group_invites.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/widgets/group_invite_count.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/routes.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key, required this.username, required this.authService})
      : super(key: key);
  final String username;
  final AuthService authService;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

  // get image from gallery
  Future<XFile?> getImageFromGalleryMobile() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    return image;
  }

  // get image from camera
  Future<XFile?> getImageFromCameraMobile() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  Future<Image?> getImageFromGalleryWeb() async {
    Image? image = await ImagePickerWeb.getImageAsWidget();
    return image;
  }

  // upload profile image to firebase storage
  Future<String?> uploadProfileImage(XFile image) async {
    // upload image to firebase storage
    Reference storageReference = FirebaseStorage.instance.ref();

    // get a reference to the profileImage folder. If it does not exist make one.
    Reference referenceProfileImage = storageReference.child('profileImage');
    // create unique reference identifier with DateTime
    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    // create a unique reference identifier for the image
    referenceProfileImage = referenceProfileImage.child(uniqueId);
    try {
      // upload the image to firebase storage
      // image.path won't work on web.
      await referenceProfileImage.putFile(File(image.path));

      // get the download url of the image
      String downloadUrl = await referenceProfileImage.getDownloadURL();
      debugPrint(downloadUrl);
      return downloadUrl;
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: 0, vertical: MediaQuery.of(context).size.height * 0.1),
        children: [
          GestureDetector(
            child: const CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
            ),
            onTap: () async {
              // select image from gallery or camera
              XFile? image = await getImageFromGalleryMobile();
              if (image == null) {
                return;
              }
              final imageWeb = await image.readAsBytes();

              //upload image to firebase storage
              Reference storageReference = FirebaseStorage.instance.ref();
              Reference profileImageReference =
                  storageReference.child("profileImage");
              String uniqueId =
                  DateTime.now().millisecondsSinceEpoch.toString();
              profileImageReference = profileImageReference.child(uniqueId);
              try {
                await profileImageReference.putData(imageWeb);
                String downloadUrl =
                    await profileImageReference.getDownloadURL();
                debugPrint(downloadUrl);
              } catch (e) {
                debugPrint("Error: ${e.toString()}");
              }
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          const Divider(
            thickness: 2,
            height: 0,
          ),
          ListTile(
            enabled: false,
            enableFeedback: false,
            iconColor: Colors.black,
            selectedColor: Colors.black,
            selected: true,
            leading: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text(
              widget.username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            thickness: 2,
            height: 0,
          ),
          ListTile(
            iconColor: Colors.black,
            onTap: () {
              Navigator.pushNamed(context, Routes.settings);
            },
            selectedColor: Colors.black,
            selected: true,
            leading: const Icon(Icons.settings),
            title: const Text(
              "Settings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            iconColor: Colors.black,
            onTap: () {
              // go to groupInvites page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GroupInvitesPage(),
                ),
              );
            },
            selectedColor: Colors.black,
            selected: true,
            leading: const Icon(Icons.text_snippet_rounded),
            trailing: Container(
              width: 50,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: databaseService.getGroupInvites(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const GroupInviteCount(
                        widget: CircularProgressIndicator());
                  }

                  if (snapshots.hasError) {
                    return GroupInviteCount(
                        widget: Text('Error: ${snapshots.error}'));
                  }

                  return GroupInviteCount(
                    widget: Text(
                      snapshots.data!.size.toString(),
                    ),
                  );
                },
              ),
            ),
            title: const Text(
              "Group Invites",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            iconColor: Colors.black,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Logout",
                    ),
                    content: const Text(
                      "Are you sure you want to log out?",
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
                          widget.authService.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.login, (route) => false);
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          size: 25,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            selectedColor: Colors.black,
            selected: true,
            leading: const Icon(Icons.logout),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
