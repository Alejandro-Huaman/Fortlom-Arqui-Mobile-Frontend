import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortloom/domain/entities/SongResource.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongWidget extends StatefulWidget {
  const SongWidget({Key? key,required this.songResource}) : super(key: key);
  final SongResource songResource;
  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  var videoURL="";

  @override
  void initState() {
     this.videoURL = widget.songResource.musicUrl;

  }
  @override
  Widget build(BuildContext context) {
    void _launchUrl(Uri url) async {
      if (!await launchUrl(url)) throw 'Could not launch $url';
    }
    return Card(
          color: Colors.grey,
         elevation: 40.5,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(30),
         ),
         child: Column(
           children: [

             Text(widget.songResource.name,textAlign: TextAlign.center,style: TextStyle(
               fontSize: 30,
               fontWeight: FontWeight.w700,
               color: Colors.black
             ),),
             Align(
               alignment: Alignment.bottomRight,
               child: Text(
                   "Category: ${widget.songResource.category}"
               ),
             ),
             SizedBox(height: 30,),
            Container(
              height: 100,
              width: 300,
              child: FloatingActionButton(
                onPressed: (){
                  Uri _urlF = Uri.parse(this.videoURL );
                  _launchUrl(_urlF);

                },
                backgroundColor: Colors.lightGreen,
                child: Icon(FontAwesomeIcons.youtube,color: Colors.red,size: 40,),
              ),
            ),
             SizedBox(height: 30,),



           ],


         ),




    );
  }
}
