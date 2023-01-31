import 'package:flutter/material.dart';
import 'package:flutter_front_end/screens/post_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../utils/constants.dart';

class PostWidget extends StatelessWidget {
  PostWidget({required this.postData, super.key}) {
    title = postData["title"] ?? "";
    authorName = postData["author"]?["displayName"] ?? "";
    content = postData["content"] ?? "";
    final date = DateTime.parse(postData["createdAt"] ?? "");
    timeagoStr = timeago.format(date);
  }
  final postData;
  late String title;
  late String authorName;
  late String content;
  late String timeagoStr;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostPage(postData: postData),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom:
                BorderSide(width: 1, color: Color.fromARGB(255, 136, 136, 136)),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$authorName - $timeagoStr',
              style: const TextStyle(color: Color.fromARGB(255, 186, 186, 186)),
            ),
            const SizedBox(height: 5),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
