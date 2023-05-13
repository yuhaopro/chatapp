import 'package:flutter/material.dart';

class GroupData extends ChangeNotifier{
  final List<String> _usernames = [];
  String _groupName = "";
  List<String> get getUsernames => _usernames;
  String get getGroupName => _groupName;

  void setGroupName(String name) {
    _groupName = name;
    notifyListeners();
  }

  void addMember(String username) {
    _usernames.add(username);
    notifyListeners();
  }

  void removeMember(String username) {
    _usernames.remove(username);
    notifyListeners();
  }

  void clearMembers() {
    _usernames.clear();
    notifyListeners();
  }
}