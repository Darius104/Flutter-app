import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/api_request.dart';

class UserData extends ChangeNotifier {
  String _name = "";
  String _email = "";
  late int _id;

  void updateUserData(
      {required int id, required String name, required String email}) {
    _name = name;
    _email = email;
    _id = id;
    notifyListeners();
  }

  void getUserData({required String email}) async {
    String jsonData = await ApiRequest.getAuthors();
    if (jsonData == null) return;
    final List authorsList = jsonDecode(jsonData);

    final author =
        authorsList.where((element) => element["email"] == email).toList()[0];
    final id = author["code"];
    final name = author["displayName"];

    updateUserData(id: id, name: name, email: email);
  }

  String get name => _name;
  String get email => _email;
  int get id => _id;
}
