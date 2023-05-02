import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData customThemeData() {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        focusColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
  static Color iconBlackFocused() {
    return MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return Colors.black;
      }
      if (states.contains(MaterialState.error)) {
        return Colors.red;
      }
      return Colors.grey;
    });
  }

  static Color textfocusedState(FocusNode _focusstate) {
    if (_focusstate.hasFocus)
      {
        return Colors.black;
      }
    return Colors.grey;
  }

}
