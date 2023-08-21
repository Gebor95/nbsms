import 'package:flutter/material.dart';

import 'package:nbsms/api/api_service.dart';

class SelectedContactsProvider extends ChangeNotifier {
  List<Contactt> _selectedContacts = [];
  List<Contactt> get selectedContacts => _selectedContacts;

  void updateSelectedContacts(List<Contactt> newSelectedContacts) {
    _selectedContacts = newSelectedContacts;
    notifyListeners();
  }
}

class ContactModel {
  final String name;
  final String mobile;

  ContactModel({required this.name, required this.mobile});
}

class HomeProvider extends ChangeNotifier {
  List<ContactModel> personalContacts = [];
  String balance = " Loading";

  void loadPersonalContacts(List<ContactModel> contacts) {
    personalContacts = contacts;
    notifyListeners();
  }

  void updateBalance(String newBalance) {
    balance = newBalance;
    notifyListeners();
  }
}
