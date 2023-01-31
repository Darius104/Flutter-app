import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/modify_post_page.dart';
import 'package:flutter_front_end/widgets/comment_widget.dart';
import 'package:flutter_front_end/widgets/comments_list.dart';
import 'package:flutter_front_end/widgets/post_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/post_list_data.dart';
import '../models/user_data.dart';
import '../services/api_request.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class PostPage extends StatefulWidget {
  PostPage({required this.postData, super.key}) {
    title = postData["title"] ?? "";
    postId = postData["code"] ?? "";
    content = postData["content"] ?? "";
    date = DateTime.parse(postData["createdAt"] ?? "");
    timeagoStr = timeago.format(date);
  }

  final postData;
  late String title;
  late final date;
  late int postId;
  late String content;
  late String timeagoStr;
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _commentController = TextEditingController();

  List comments = [];

  void getComments() async {
    final String response = await ApiRequest.getSinglePosts(widget.postId);

    if (response.startsWith("error:")) {
      if (response.contains("Unauthorized")) {
        showAlert(
            context: context,
            messageErr: "Your not anymore authorized, please login.",
            title: "Unauthorized");
        return;
      }
      showAlert(
          context: context,
          messageErr: "Something went wrong try again",
          title: "Error");
      return;
    }
    setState(() {
      comments = jsonDecode(response)["Comments"];
    });
  }

  void sendComment() async {
    if (_commentController.text == "") return;
    FocusManager.instance.primaryFocus?.unfocus();
    final String response = await ApiRequest.commentPost(
        content: _commentController.text,
        replyTo: widget.postId,
        id: Provider.of<UserData>(context, listen: false).id);

    if (response.startsWith("error:")) {
      if (response.contains("Unauthorized")) {
        showAlert(
            context: context,
            messageErr: "Your not anymore authorized, please login.",
            title: "Unauthorized");
        return;
      }
      showAlert(
          context: context,
          messageErr: "Something went wrong try again",
          title: "Error");
      return;
    }
    _commentController.clear();
    getComments();
  }

  void deletePost() async {
    final String response = await ApiRequest.deletePost(widget.postId);
    if (response.startsWith("error:")) {
      if (response.contains("Unauthorized")) {
        showAlert(
            context: context,
            messageErr: "Your not anymore authorized, please login.",
            title: "Unauthorized");
        return;
      }
      showAlert(
          context: context,
          messageErr: "Something went wrong try again",
          title: "Error");
      return;
    }
    Provider.of<PostListData>(context, listen: false).getPostList(context);

    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    final String myEmail = Provider.of<UserData>(context, listen: false).email;
    final String postAuthorEmail = widget.postData["author"]?["email"] ?? "";

    final bool isMyPost = myEmail == postAuthorEmail;

    return WillPopScope(
      onWillPop: () async {
        await Provider.of<PostListData>(context, listen: false)
            .getPostList(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
          actions: [
            isMyPost
                ? PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.edit_note),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Modify")
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Delete")
                          ],
                        ),
                      ),
                    ],
                    offset: const Offset(0, 50),
                    color: Color.fromARGB(255, 72, 72, 72),
                    elevation: 2,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.0),
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 1) {
                        debugPrint("$value");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifyPostPage(
                                postId: widget.postId,
                                title: widget.title,
                                content: widget.content),
                          ),
                        );
                      }
                      if (value == 2) {
                        debugPrint("deleting...");
                        deletePost();
                      }
                    },
                  )
                : Container()
          ],
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration:
                      const InputDecoration(hintText: "Add a comment..."),
                ),
              ),
              InkWell(
                onTap: sendComment,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Send"),
                ),
              )
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getComments();
          },
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostWidget(postData: widget.postData),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
                    "comments:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommentsList(commentsList: comments),
                const SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
