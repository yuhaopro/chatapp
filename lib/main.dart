import 'package:chatapp/services/sharedpreferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:chatapp/services/utils/constants.dart';
import 'package:chatapp/screens/export_pages.dart';
import 'package:chatapp/theme/theme.dart';

void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // initialize web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    // initialize android
    await Firebase.initializeApp();
  }
  // Run the MyApp widget
  runApp(MyApp());
}

// needs to be stateful so we can access the init constructor
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // _varname is a way to specify private variables
  bool _isSignedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  // check if user is signed in before building the app
  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isSignedIn = value;
      }
      debugPrint("debug: $_isSignedIn");
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    else {
      return MaterialApp(
        theme: AppTheme.customThemeData(),
        debugShowCheckedModeBanner: false,
        // if user is signed in, show the home page, otherwise show the login page
        home: _isSignedIn ? const HomePage() : const LoginPage(),
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
        }
      );
    }
  }
}
