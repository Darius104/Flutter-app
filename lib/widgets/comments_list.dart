import 'package:flutter/material.dart';
import 'package:flutter_front_end/widgets/comment_widget.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({required this.commentsList, super.key});

  final List? commentsList;

  @override
  Widget build(BuildContext context) {
    if (commentsList == null) return const Center(child: Text("Loading..."));
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: commentsList!.length,
      itemBuilder: (context, index) {
        return CommentWidget(commentData: commentsList![index]);
      },
    );
  }
}
