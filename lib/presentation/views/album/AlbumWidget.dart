import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/ImagePublicationService.dart';
import 'package:fortloom/presentation/views/album/SongView.dart';

import '../../../domain/entities/AlbumResource.dart';
import '../../../domain/entities/ImageResource.dart';
import '../posts/widgets/imagePost.dart';

class AlbumWidget extends StatefulWidget {
  const AlbumWidget({Key? key,required this.album,required this.canpost}) : super(key: key);
  final AlbumResource album;
  final bool canpost;
  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {

  int number=0;
  List<ImageResource> imalist = [];
 final ImagePublicationService imagePublicationService= new ImagePublicationService();
  int list=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.number=widget.album.id;
    this.imagePublicationService.getImageByAlbumId(this.number).then((value){

      setState(() {

        imalist=value;
        list=imalist.length;

      });


    });




  }


  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey,
        elevation: 30.5,
        child: Column(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  widget.album.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ) ,
            ),
            SizedBox(height: 10,),
            Text(widget.album.Description,style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),),
            SizedBox(height: 10,),
            if(list!=0)...[

              CarouselSlider.builder(
              itemCount: list,
              itemBuilder: (context, index,realIndex) {
              return imagePost(image: imalist[index]);
              },
              options: CarouselOptions(height: 350,
              viewportFraction: 1,
              enableInfiniteScroll: false
              ),
            )],
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 170,
                 child: ElevatedButton(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),


                   ),
                   onPressed: (){

                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => SongView(album: this.number,post: widget.canpost,)),
                     );




                   },
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Text("See Songs",
                         style: TextStyle(
                           color: Colors.redAccent,
                           fontWeight: FontWeight.w700,
                         fontSize: 20
                       ),


                       ),
                       SizedBox(width: 5,),
                       Icon(
                         Icons.music_note,
                         size: 30,
                       ),
                     ],
                   ),


                 ),
             )


            )
          ],
        )

    );
  }
}
