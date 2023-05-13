import 'package:flutter/material.dart';
import 'package:chatapp/screens/routes.dart';
import 'package:chatapp/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key, required this.username, required this.authService}) : super(key: key);
  final String username;
  final AuthService authService;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: MediaQuery.of(context).size.height * 0.1),
        children: [
          ListTile(
            title: const Icon(
              Icons.account_circle,
              size: 150,
            ),
            onTap: () {},
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
              username,
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
            onTap: () {},
            selectedColor: Colors.black,
            selected: true,
            leading: const Icon(Icons.text_snippet_rounded),
            title: const Text(
              "About",
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
                          authService.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
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
