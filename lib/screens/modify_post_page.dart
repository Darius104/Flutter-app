import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_front_end/models/post_list_data.dart';
import 'package:flutter_front_end/services/api_request.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../utils/utils.dart';
import './login_page.dart';

class ModifyPostPage extends StatelessWidget {
  ModifyPostPage(
      {required this.postId,
      required this.title,
      required this.content,
      super.key});
  final int postId;
  final String title;
  final String content;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  void modifyPost(context) async {
    debugPrint(
        "title : ${_titleController.text} content: ${_contentController.text}");
    if (_contentController.text == "" || _titleController.text == "") return;

    final String response = await ApiRequest.modifyPost(
        postId: postId,
        title: _titleController.text,
        content: _contentController.text,
        authorCode: Provider.of<UserData>(context, listen: false).id);

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
    await Provider.of<PostListData>(context, listen: false)
        .getPostList(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _titleController = TextEditingController(text: title);
    _contentController = TextEditingController(text: content);
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
                InkWell(
                  onTap: () {
                    modifyPost(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Modify"),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(hintText: "Title..."),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "Content...",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            )
          ],
        ),
      )),
    );
  }
}
