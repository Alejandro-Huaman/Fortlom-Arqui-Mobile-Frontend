

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/core/service/ReportService.dart';
import 'package:fortloom/domain/entities/ForumResource.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';

import '../../../core/service/AuthService.dart';
import '../../../core/service/ForumCommentService.dart';
import '../../../domain/entities/ForumCommentResource.dart';
import '../../widgets/screenBase.dart';


class ForumPage extends StatefulWidget {

  final ForumResource forumResource;

  const ForumPage({Key? key,required this.forumResource}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState(forumResource);
}

class _ForumPageState extends State<ForumPage> {

   late ForumResource forumResourceo;
   ForumCommentService forumCommentService = new ForumCommentService();
   AuthService authService= new AuthService();
   ReportService reportService=new ReportService();
   String username="Usuario";
   _ForumPageState(ForumResource forumResourcejj){
    PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
     forumResourceo = new ForumResource(0, "forumname", "forumdescription", personResource);
    forumResourceo=forumResourcejj;
  }
   PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");

   final TextEditingController createcomment = new TextEditingController();
   final TextEditingController report = new TextEditingController();
   Future<List<ForumCommentResource>> getdata(int id){

     return forumCommentService.getbyForumID(id);
   }
   @override
   void initState() {

     super.initState();
     this.getdata(forumResourceo.id);

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

   void AddForumComment(){

     forumCommentService.addForumComment(createcomment.text.trim(), this.forumResourceo.id,this.personResource.id).then((result){


       setState(() {
         createcomment.text="";
         this.getdata(forumResourceo.id);
       });



     });




   }
   
   Future<int> AddReport(){
     var result=reportService.createreport(report.text.trim(), personResource.id, forumResourceo.person.id);

     return result;
     
   }

   






  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenBase(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.grey,
                child: Column(
                  children: [
                       Text(this.forumResourceo.forumname,
                       style: TextStyle(fontSize: 20),
                       ),
                       SizedBox(height: 7),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black54,
                        ),

                        child:IconButton(
                            icon: const Icon(Icons.flag),
                            onPressed: () {
                              showDialog(context: context,
                                  barrierDismissible: false,
                                  builder: (context)=> AlertDialog(

                                    title: Text("Reporte al Foro"),
                                    content: Container(
                                      width: 200,
                                      child: TextField(
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 20,
                                        maxLength: 100,
                                        controller: report,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Description',

                                        ),
                                      ),
                                    ),
                                    actions: [
                                        FloatingActionButton(
                                             child:Text("Ok"),
                                             onPressed: (){

                                                  AddReport();

                                                 Fluttertoast.showToast(
                                                     msg: "Reporte Enviado",
                                                     toastLength: Toast.LENGTH_SHORT,
                                                     gravity: ToastGravity.CENTER,
                                                     textColor: Colors.white,
                                                     fontSize: 16.0

                                                 );




                                             Navigator.of(context).pop();
                                             },),


                                      FloatingActionButton(
                                      child:Text("Cancel"),
                                      onPressed: (){
                                      Navigator.of(context).pop();
                                       },
                                       )
                                    ],

                                  )

                                  );
                            }
                        ),
                      ),
                      ) ,

                    Align(
                        alignment: Alignment.topLeft,
                        child:Text(this.forumResourceo.person.realname+"    "+ this.forumResourceo.person.lastname,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child:Text(this.forumResourceo.forumdescription,
                          style: TextStyle(
                              fontSize: 10
                          ),
                        ),
                    ),

                  ],
                ),
              ),

              FutureBuilder<List<ForumCommentResource>>(
                future: getdata(forumResourceo.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if(snapshot.hasData){


                    return itemList(list: snapshot.data,report: this.report,personResource: this.personResource,);

                  }
                  return Text("Correct");

                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 200,
                  child: Card(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Text("Write a Comment",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 200,

                          child:TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 20,
                            maxLength: 1000,
                            controller: createcomment,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description',

                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton(onPressed:(){
                              AddForumComment();
                            },
                              shape: RoundedRectangleBorder(),
                              child: Text("Accept"),
                            ) ,
                            FloatingActionButton(onPressed:(){
                                   createcomment.text="";
                            },
                              shape: RoundedRectangleBorder(),
                              backgroundColor: Colors.red,
                              child: Text("Delete"),
                            ) ,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}















class itemList extends StatelessWidget {
  final List<ForumCommentResource>? list;
  final TextEditingController report;
  final PersonResource personResource;
  const itemList({Key? key,required this.list,required this.report,required this.personResource}) : super(key: key);



  Future<int> AddReportincomment(int id){

    ReportService reportService=new ReportService();
    var result=reportService.createreport(report.text.trim(), personResource.id, id);

    return result;

  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: list == null ? 0 : list?.length,
        itemBuilder: (context,index){
          return Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 200,
              child: Card(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Text(list![index].commentdescription,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 7),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black54,
                          ),

                          child:IconButton(
                              icon: const Icon(Icons.flag),
                              onPressed: () {

                                showDialog(context: context,
                                    barrierDismissible: false,
                                    builder: (context)=> AlertDialog(

                                      title: Text("Reporte al Foro"),
                                      content: Container(
                                        width: 200,
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 20,
                                          maxLength: 100,
                                          controller: report,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Description',

                                          ),
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child:Text("Ok"),
                                          onPressed: (){

                                            AddReportincomment(list![index].person.id);

                                            Fluttertoast.showToast(
                                                msg: "Reporte Enviado",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                textColor: Colors.white,
                                                fontSize: 16.0

                                            );




                                            Navigator.of(context).pop();
                                          },),


                                        FloatingActionButton(
                                          child:Text("Cancel"),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],

                                    )

                                );



                              }
                          ),
                        ),
                      ) ,
                      Align(
                        alignment: Alignment.topLeft,
                        child:Text(list![index].person.realname+"  "+list![index].person.lastname,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child:Text(list![index].registerdate,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          );
        });
  }
}

