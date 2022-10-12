
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fortloom/core/service/ForumService.dart';
import 'package:fortloom/presentation/views/Forum/ForumCreate.dart';
import 'package:fortloom/presentation/views/Forum/ForumPage.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/sidebarLayout.dart';
import '../../../domain/entities/ForumResource.dart';
import '../../widgets/sideBar/navigationBloc.dart';


class ForumSection extends StatefulWidget with NavigationStates{
  const ForumSection({Key? key}) : super(key: key);

  @override
  State<ForumSection> createState() => _ForumSectionState();
}

class _ForumSectionState extends State<ForumSection> {

  ForumService forumService=ForumService();




   List<ForumResource> getforums=[];

   Future<List<ForumResource>> getdata(){

     return forumService.getall();
   }


  navigatetoForumCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForumCreate()),
    );

    if (result) {
      this.getdata();
      setState(() {});
    }
  }



  @override
  void initState() {

    super.initState();
    this.getdata();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
         home:ScreenBase(

           body: SingleChildScrollView(
             physics: ClampingScrollPhysics(),
             child:  Column (
               children: <Widget>[

                 Padding(padding: const EdgeInsets.only(left: 350),
                   child:Ink(
                     decoration: const ShapeDecoration(
                       color: Colors.blueGrey,
                       shape: CircleBorder(),
                     ),

                     child: IconButton(

                       icon: const Icon(Icons.add),
                       color: Colors.black,
                       onPressed: () => navigatetoForumCreate(context),

                     ),

                   ),
                 ),
                 FutureBuilder<List<ForumResource>>(
                   future: getdata(),
                   builder: (context, snapshot) {
                     if (snapshot.hasError) print(snapshot.error);
                     if(snapshot.hasData){
                       print(snapshot.data);

                       return ItemList(list: snapshot.data!);

                     }
                     return Text("Correct");

                   },
                 ),





               ],
             ),
           )


         ) ,


      
    );

  }

  
  
  
  



}
class ItemList extends StatelessWidget {
  final List<ForumResource>?list;

  const ItemList({Key? key, required this.list,}) : super(key: key);

  navigatetoForumPage(BuildContext context,ForumResource forumResource) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForumPage(forumResource: forumResource,)),
    );

    if (result) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),

        shrinkWrap: true,
        itemCount: list == null ? 0 : list?.length,
        itemBuilder: (context,index){
          return Container(
              height: 150,
              width: 300,
              child: Card(
              child: Column(
                  children: <Widget>[
                    Align(alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 18,
                        width: 20,
                        child: FloatingActionButton(
                          heroTag: 'tagImage$index',
                            shape: RoundedRectangleBorder(),
                            child: Icon(Icons.arrow_forward_ios,
                              size: 18,
                            ),

                          onPressed: () => navigatetoForumPage(context,list![index]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.all(10.0),


                      child: Text(
                          list![index].forumname, style: TextStyle(fontSize: 20)),

                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(list![index].person.realname + "    " +
                          list![index].person.lastname,
                        style: TextStyle(fontSize: 10),


                      ),
                    )

                  ]
              )
              )
          );
        });
  }
}
