import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/post_list_data.dart';
import 'package:provider/provider.dart';

import '../services/api_request.dart';
import '../widgets/post_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PostListData>(context, listen: false).getPostList(context);
  }

  @override
  Widget build(BuildContext context) {
    List onlyPostList = Provider.of<PostListData>(context)
        .postList
        .where((element) => element["replyTo"] == null)
        .toList();

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: () async {
          Provider.of<PostListData>(context, listen: false)
              .getPostList(context);
        },
        child: PostList(postList: onlyPostList),
      ),
    );
  }
}
