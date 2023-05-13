import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';
import 'sp_helper.dart';
class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //login
  Future loginEmailandPassword(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      if (user != null) {
        return true;
      }

    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // register
  Future registerEmailandPassword(String username, String email, String password) async {
    try {
      // register in firebase with email and password
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      // improvement in security can be made by having the database updated on the server side here.
      await DatabaseService(uid: user.uid).updateUserData(username, email);
      return true;


    // catch error
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }


  // signOut
  Future signOut() async {
    try {
      await SPHelper.removeUserdata();
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}