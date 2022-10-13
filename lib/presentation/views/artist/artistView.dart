import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fortloom/core/service/ArtistService.dart';
import 'package:fortloom/core/service/FollowService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:http/src/response.dart';

import '../../../core/service/AuthService.dart';
import '../../../domain/entities/PersonResource.dart';
import '../../widgets/screenBase.dart';

class ArtistView extends StatefulWidget with NavigationStates {
  const ArtistView({Key? key}) : super(key: key);

  @override
  State<ArtistView> createState() => _ArtistState();
}

class _ArtistState extends State<ArtistView> {
  int likes = 11;
  String imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/640px-PNG_transparency_demonstration_1.png";
  ArtistService artistService=new ArtistService();
  AuthService authService= new AuthService();
  String username="Usuario";
  PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
  bool post = false;
  var nametextfield = TextEditingController();
  var descriptiontextfield = TextEditingController();
  var datetextfield = TextEditingController();
  String fechastring = "fecha";
  DateTime fechadescription = DateTime(2022,06,15);
  DateTime fechapredefinida = DateTime.now();

  Future<List<ArtistResource>> getdata(){
    return artistService.getallArtists();
  }

  @override
  void initState() {
    this.getdata();
    super.initState();
    String tep;
    this.authService.getToken().then((result){
      setState(() {
        tep= result.toString();
        username=this.authService.GetUsername(tep);
        this.authService.getperson(username).then((result) {
          setState(() {
            personResource=result;
          });
        });
      });
    }) ;
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtistResource>>(future: getdata(), builder:(context, snapshot){
      if(snapshot.hasError) print(snapshot.error);
      if(snapshot.hasData) {
        print("data:${snapshot.data}");
        return ItemList(artistList: snapshot.data, personResource: personResource);
      } else {
        return const Center(child: CircularProgressIndicator(),);
      }
      //return ItemList(artistList: snapshot.data, personResource: personResource); //esta línea es hardcoded porque se regresa si no hay data, puede generar error
    });
  }
}

class ItemList extends StatefulWidget {
  const ItemList({Key? key, required this.personResource, required this.artistList}) : super(key: key);
  final List<ArtistResource>? artistList;
  final PersonResource personResource;
  @override
  State<ItemList> createState() => _ItemListState(artistList: artistList, personResource: personResource);
}

class _ItemListState extends State<ItemList> {
  _ItemListState({Key? key, required this.personResource, required this.artistList});
  List<ArtistResource>? artistList;
  final PersonResource personResource;

  Future<Response> createFollow(int artistId, int fanaticId) {
    FollowService followService = new FollowService();
    var result = followService.createFollow(artistId, fanaticId);
    return result;
  }

  Future<Response> updateArtist(int artistfollowers,int artistId){
    ArtistService artistService = new ArtistService();
    var result = artistService.updateArtist(artistfollowers, artistId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: artistList?.length,
          itemBuilder: (context, index) {
            return  Card(
              color: Colors.grey,
              child: Column(
                children: [
                  Container(
                    child: Image.network(artistList![index].content!),
                    height: 200,
                  ),

                  ListTile(
                    title: Center(
                        child: Text(
                          artistList![index].username,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                    ),
                  ),

                  RatingBar(
                    initialRating: Random(artistList![index].id*9999).nextDouble()*5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                        ),
                        empty: const Icon(
                          Icons.star_outline,
                          color: Colors.orange,
                        )),
                    onRatingUpdate: (double value) {
                      //here goes API call for updating rating
                    },
                  ),

                  Row(
                    children: [
                      Text(artistList![index].artistfollowers.toString()),
                      TextButton(
                          child:Text("FOLLOW"),
                          onPressed: (){
                            createFollow(artistList![index].artistfollowers, personResource.id);
                            updateArtist(artistList![index].artistfollowers+1, artistList![index].id);
                            setState(() {
                              artistList![index].artistfollowers++;
                            });
                          }
                      ),
                      TextButton(
                        child:Text("UNFOLLOW"),
                        onPressed: () {
                          updateArtist(artistList![index].artistfollowers-1, artistList![index].id);
                          setState(() {
                            artistList![index].artistfollowers --;
                          });
                        }
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  ),
                ],
              ),
              elevation: 8,
              shadowColor: Colors.black,
              margin: EdgeInsets.all(20),
              shape:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 1)
              ),
            )
            ;
          }
      ),
    );
  }
}

