// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/post_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatelessWidget {
  CommentWidget({required this.commentData, super.key}) {
    comment = commentData["content"];
    dateComment = commentData["createdAt"];
    final date = DateTime.parse(dateComment);
    dateCommentStr = timeago.format(date);
    authorName = commentData["author"]?["displayName"] ?? "";
  }

  final commentData;
  late String comment;
  late String dateComment;
  late String dateCommentStr;
  late String authorName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$authorName ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("- $dateCommentStr"),
            ],
          ),
          const SizedBox(height: 5),
          Text("$comment"),
        ],
      ),
    );
  }
}
