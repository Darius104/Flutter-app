import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/api_request.dart';
import '../utils/utils.dart';

class PostListData extends ChangeNotifier {
  List _postList = [];

  Future<void> getPostList(context) async {
    final jsonData = await ApiRequest.getPosts();
    if (jsonData.contains("Unauthorized")) {
      showAlert(
          context: context,
          messageErr: "Your not anymore authorized, please login.",
          title: "Unauthorized");
      return;
    }
    if (jsonData == null) return;

    _postList = jsonDecode(jsonData).reversed.toList();
    notifyListeners();
  }

  int get postListLenght => _postList.length;
  UnmodifiableListView get postList => UnmodifiableListView(_postList);
}
