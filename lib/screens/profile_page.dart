import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/widgets/comments_list.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../models/post_list_data.dart';
import '../models/user_data.dart';
import '../services/api_request.dart';
import '../widgets/post_list.dart';

class ProfilePage extends StatefulWidget {
  final String emailUser;
  const ProfilePage({required this.emailUser, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void initState() {
    super.initState();

    Provider.of<PostListData>(context, listen: false).getPostList(context);
  }

  @override
  Widget build(BuildContext context) {
    final List onlyMyPostList = Provider.of<PostListData>(context)
        .postList
        .where((element) =>
            element["replyTo"] == null &&
            element["author"]?["email"] != null &&
            element["author"]["email"] == widget.emailUser)
        .toList();
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<PostListData>(context, listen: false).getPostList(context);
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                  "Name: ${Provider.of<UserData>(context, listen: false).name}",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1, color: Color.fromARGB(255, 136, 136, 136)),
                ),
              ),
              child: Text(
                  "Email: ${Provider.of<UserData>(context, listen: false).email}",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: const Text("Your post:",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            PostList(postList: onlyMyPostList)
          ],
        ),
      ),
    );
  }
}
