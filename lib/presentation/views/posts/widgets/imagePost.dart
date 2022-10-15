import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/ImageResource.dart';

class imagePost extends StatefulWidget {
  const imagePost({Key? key, required this.image}) : super(key: key);
  final ImageResource image;
  @override
  State<imagePost> createState() => _imagePostState();
}

class _imagePostState extends State<imagePost> {
  @override
  Widget build(BuildContext context) {
    return

      Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[600],

        image: DecorationImage(
            image: NetworkImage(
                widget.image.imagenUrl),
            fit: BoxFit.cover),
      ),
    );
  }
}
