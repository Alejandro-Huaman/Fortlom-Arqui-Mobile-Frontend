import 'dart:developer';

import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/EventResource.dart';
import 'package:fortloom/presentation/views/event/eventlistview.dart';
import 'package:intl/intl.dart';

import '../../../core/service/AuthService.dart';
import '../../../core/service/EventService.dart';
import '../../../domain/entities/PersonResource.dart';

class EventMainView extends StatefulWidget with NavigationStates{
  const EventMainView({Key? key}) : super(key: key);

  @override
  State<EventMainView> createState() => _EventState();
}

class _EventState extends State<EventMainView> {

  EventService eventService=new EventService();
  AuthService authService= new AuthService();
  String username="Usuario";
  PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
  bool post = false;
  bool isupdagrade=false;
  var nametextfield = TextEditingController();
  var descriptiontextfield = TextEditingController();
  var datetextfield = TextEditingController();
  String fechastring = "fecha";
  DateTime fechadescription = DateTime(2022,06,15);
  DateTime fechapredefinida = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
      body:SingleChildScrollView(
          child:Center(
            child:Container(
              child:Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    if(isupdagrade)...[
                      CardMainEvent(),
                    ],
                    SizedBox(height: 10,),
                    ShowForm(),
                    SizedBox(height: 10,),
                    ShowButtons()
                  ]
              )
            )
          )
      )
    );
  }

  @override
  void initState() {

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
        isupdagrade=this.authService.isartistupgrade(tep);


      });
    }) ;
  }

  Widget CardMainEvent(){
    return Card(
      child:Container(
          padding: EdgeInsets.all(10),
          width: 200,
          height: 200,
          child:Column(
            children:<Widget> [
              Text('Make a Event!'),
              SizedBox(height: 10,),
              Image(
                  image: AssetImage('assets/imgs/events_image.jpg'),
                  height: 100,
              ),
              SizedBox(height: 5,),
              RaisedButton(
                  onPressed: (){
                    setState(() {
                      post = true;
                    });
                    print(post);
                  },
                  child: Text("Post Event"),
                  color: Colors.white,
              )
            ],
          )
      )
    );
  }

  Widget PostEventForm(){
    return Card(
        child: Container(
            width: 350,
            height: 250,
            child: Column(
              children: <Widget>[
                Text("Create your Event!"),
                SizedBox(height: 10,),
                TextField(
                  controller: nametextfield,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'EventName',
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: descriptiontextfield,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'EventDescription',
                  ),
                ),
                SizedBox(height: 10,),
                IconButton(
                    onPressed: () async{
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            initialDate: fechapredefinida
                        );

                        if(newDate == null) return;
                        setState(() {
                          fechadescription = newDate;
                          print(fechadescription);
                        });
                      },
                    icon: Icon(Icons.calendar_month)
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    RaisedButton(
                        onPressed: (){
                          setState(() {
                            post = false;
                          });
                          print(post);
                        },
                        child:Text("Cancel"),
                        color:Colors.white
                    ),
                    SizedBox(width: 10,),
                    RaisedButton(
                        onPressed: (){
                          nametextfield.text = '';
                          descriptiontextfield.text = '';
                          datetextfield.text = '';
                        },
                        child:Text("Clean"),
                        color:Colors.white
                    ),
                    SizedBox(width: 10,),
                    RaisedButton(
                        onPressed: (){
                          print("Fecha a utilizar: $fechadescription");
                          String fechaevento = DateFormat('yyyy-MM-ddTHH:mm:ss').format(fechadescription); //parse me ayuda para convertir un string a Datetime y format de datetime a string
                          print("Nueva Fecha convertida: $fechaevento");
                          eventService.addEvents(nametextfield.text.trim(), descriptiontextfield.text.trim(), "link", fechaevento, personResource.id);
                        },
                        child:Text("Create and Post"),
                        color:Colors.white
                    )
                  ],
                )
              ],
          )
        )
    );
  }

  Widget ShowButtons(){
    return Center(
          child: RaisedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventListView())
                );
              },
              child: Text("Show All Events"),
              color:Colors.white
          ),
        );
  }

  Widget ShowForm(){
    if(post){
      return PostEventForm();
    }else{
      return Icon(
          Icons.cancel,
          color: Colors.white
      );
    }
  }

}


