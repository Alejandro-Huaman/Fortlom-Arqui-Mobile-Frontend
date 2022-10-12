import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/PostService.dart';
import 'package:fortloom/domain/entities/PostResource.dart';
import 'package:fortloom/presentation/views/posts/widgets/comentsDialog.dart';
import 'package:fortloom/presentation/views/posts/widgets/reportDialog.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenWH(context).width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [headerPost(), body()],
      ),
    );
  }

  Widget headerPost() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://source.unsplash.com/random/200x200?sig=${DateTime.now().millisecondsSinceEpoch}")),
              SizedBox(width: 15),
              Text(
                widget.post.artist.username,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.report,
              color: Colors.redAccent.withOpacity(0.6),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => reportDialog(
                  userReported: widget.post.artist.id,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.post.publicationDescription,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[600],
              image: DecorationImage(
                  image: NetworkImage(
                      "https://source.unsplash.com/random/200x200?sig=${DateTime.now().millisecondsSinceEpoch}"),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.post.likes++;
                  });
                  _postService.uptPost(widget.post);
                },
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up),
                    const SizedBox(width: 5),
                    Text(
                      widget.post.likes.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CommetsDialog(
                        postId: widget.post.id,
                        // post: widget.post,
                      ),
                    );
                  },
                  child: const Text(
                    "View Comments",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
