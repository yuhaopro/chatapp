import 'package:flutter/material.dart';

class Constants {
  /*
  * Firebase configuration
  * can consider using backend server to store these values
  */
  static String appId = "1:1015144719724:web:a03b1700ec7792210dbf49";
  static String apiKey = "AIzaSyDeln4MyU8ulkoTpsjamhyDlqytgtGx5oY";
  static String projectId = "chatapp-8cf21";
  static String authDomain = "chatapp-8cf21.firebaseapp.com";
  static String storageBucket = "chatapp-8cf21.appspot.com";
  static String messagingSenderId = "1015144719724";
  static Color scaffoldBackgroundColor = const Color(0xFFF2F1F8);
  static String title = "SocraticChat";

}

enum AcceptInvites {
  none,
  friends,
  everyone,
}