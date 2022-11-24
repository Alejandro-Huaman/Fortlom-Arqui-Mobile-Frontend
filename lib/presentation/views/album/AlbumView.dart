import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/AlbumService.dart';
import 'package:fortloom/domain/entities/AlbumResource.dart';
import 'package:fortloom/presentation/views/album/AlbumCreate.dart';
import 'package:fortloom/presentation/views/album/AlbumWidget.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';

import '../../../core/framework/colors.dart';
import '../../../core/service/AuthService.dart';
import '../../widgets/sideBar/navigationBloc.dart';

class AlbumView extends StatefulWidget with NavigationStates{
  const AlbumView({Key? key}) : super(key: key);


  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  final AuthService authService=AuthService();
  final AlbumService albumService= new AlbumService();
  List<AlbumResource> albums = [];
  int userId=0;
  String username = "Usuario";
  bool canpost=true;

  navigatetoAlbumCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlbumCreate(id:this.userId)),
    );


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    String tep;

    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;
          });
        });

        canpost= this.authService.isfanatic(tep);
      });
    });





    albumService.getall().then((value) {
      setState(() {
        albums = value;

      });
    });

  }

  @override
  Widget build(BuildContext context) {

    Future<void> _pullRefresh() async {
      albumService.getall().then((value) {
        setState(() {
          albums = value;
        });
      });

    }


    return ScreenBase(

        body:
        Container(

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/Battlelogo.jpg"),
                  fit: BoxFit.cover
              )
          ),
            child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                if(!canpost)...[
                  Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(goldPrimary),
                      ),
                      onPressed: (){
                        navigatetoAlbumCreate(context);
                      },
                      child: Text(
                        "New Album",style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                    ),

                  ),

                ],

                SizedBox(height: 10,),
                Expanded(
                  child: albums.isNotEmpty
                      ? RefreshIndicator(
                      child: ListView.builder(
                          itemCount: albums.length,
                          itemBuilder: (context, index) {
                            return AlbumWidget(album: albums[index],canpost: canpost,);
                          }),
                      onRefresh: _pullRefresh)
                      : const Center(child: Text("No Albums Avaliable")),
                )





              ],

            ),

            )



        ),





    );
  }


}

