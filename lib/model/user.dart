import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  String? name;
  String? email;

  void setProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
    notifyListeners();
  }
}
