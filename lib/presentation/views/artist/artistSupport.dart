import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fortloom/core/service/ImageUserService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/views/artist/artistFollow.dart';
import 'package:fortloom/presentation/views/artist/artistRate.dart';

import '../../../domain/entities/ImageResource.dart';

class artistSupport extends StatefulWidget {

  const artistSupport({Key? key, required this.artistid, required this.userid}) : super(key: key);
   final ArtistResource artistid;
  final int userid;
  @override
  State<artistSupport> createState() => _artistSupportState();
}

class _artistSupportState extends State<artistSupport> {
  ImageUserService imageUserService=ImageUserService();
  ImageResource imageResource=new ImageResource(0, "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png", 0, "0", 0);
  @override
  void initState() {

    this.imageUserService.getImageByUserId(widget.artistid.id).then((value){
      setState(() {
        this.imageResource = value[0];
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.grey,
      child: Column(
        children: [
          /* Container(
                    child: Image.network(artistList![index].content),
                    height: 200,
                  ),*/

          ListTile(
            title: Center(
                child: Text(
                  widget.artistid.username,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
          height: 300,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[600],

          image: DecorationImage(
          image: NetworkImage(
          imageResource.imagenUrl),
          fit: BoxFit.fill),
          ),
          ),
          SizedBox(
            height: 15,
          ),
         artistRate(artistid: widget.artistid.id,userid: widget.userid),

          artistFollow(artistid: widget.artistid.id,userid: widget.userid)
        ],
      ),
      elevation: 8,
      shadowColor: Colors.black,
      margin: EdgeInsets.all(20),
      shape:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1)
      ),
    );
  }
}
