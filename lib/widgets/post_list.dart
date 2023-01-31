import 'package:flutter/material.dart';
import 'package:flutter_front_end/widgets/post_widget.dart';
import 'package:provider/provider.dart';

import '../models/post_list_data.dart';

class PostList extends StatelessWidget {
  const PostList({required this.postList, super.key});

  final List? postList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: postList!.length,
      itemBuilder: (context, index) {
        if (postList![index]["title"] == null ||
            postList![index]["content"] == null) {
          return Container();
        }
        return PostWidget(
          postData: postList![index],
        );
      },
    );
  }
}
