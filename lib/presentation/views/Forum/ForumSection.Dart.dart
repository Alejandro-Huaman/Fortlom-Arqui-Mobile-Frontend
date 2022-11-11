
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


               Center(
                 child: Text(
                   'Forums',
                   style: TextStyle(
                     fontFamily: 'Roboto',
                     fontSize: 36,
                   ),

                 ),
               ),
                 SizedBox(height: 30),
                Container(
                  width: 400,
                  height: 100,
                  child: TextButton(onPressed: () => navigatetoForumCreate(context),
                    child: Text("Create Forum",
                      style: TextStyle(
                          color: Colors.black54
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.all(16.0),
                    ),

                  ),
                ),



                 SizedBox(height: 30),
                 FutureBuilder<List<ForumResource>>(
                   future: getdata(),
                   builder: (context, snapshot) {
                     if (snapshot.hasError) print(snapshot.error);
                     if(snapshot.hasData){
                       print(snapshot.data);

                       return ItemList(list: snapshot.data!);

                     }
                     return Text("No Forums Available");

                   },
                 ),
                 SizedBox(height: 30),





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
          return SizedBox(
              height: 150,
              width: 500,
              //padding: const EdgeInsets.all(10.0),
              child: InkWell(onTap: () => navigatetoForumPage(context,list![index]),

                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),

                      ),
                      color: Colors.white30,
                      child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.campaign,
                              color: Colors.yellowAccent,
                              size: 50.0,


                            ),



                            Padding(
                              padding: new EdgeInsets.all(50.0),


                              child:Center(
                                child: Text(
                                    list![index].forumname, style: TextStyle(fontSize: 20)),

                              ),
                              ),




                          ]
                      )
                  )

              ),

          );
        });
  }
}
