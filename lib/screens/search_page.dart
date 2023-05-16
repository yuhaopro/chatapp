import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/sp_helper.dart';
import 'package:chatapp/widgets/drawer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthService authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  String email = "";
  String username = "";

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
    gettingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: TextFormField(
          style: const TextStyle(
            color: Colors.white,
          ),
          key: _formKey,
          controller: _searchController,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            labelText: "search",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Icon(
              Icons.search,
            ),
            prefixIconColor: Colors.white,
          ),
          onChanged: (val) {},
          validator: (val) {},
        ),
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        username: username,
        authService: authService,
      ),
      body: null,
    );
  }
}
