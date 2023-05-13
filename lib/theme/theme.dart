import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData customThemeData() {
    return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
  static Color textFormFieldColor({required FocusNode focusNode, bool error = false}) {
    if (error) {
      return Colors.red;
    }
    if (focusNode.hasFocus) {
      return Colors.black;
    }
    return Colors.grey;
  }


}
