import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/EventService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/views/Forum/ForumSection.Dart.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/EventResource.dart';

class EventListView extends StatefulWidget {
  const EventListView({Key? key}) : super(key: key);

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {

  EventService eventservice = EventService();
  List<EventResource> eventlist = [];

  Future<List<EventResource>> getdata(){
    return eventservice.getallEvents();
  }

  @override
  void initState() {

    super.initState();
    this.getdata();

  }

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        body: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Container(
                  height: 600,
                  child: FutureBuilder<List<EventResource>>(
                    future: getdata(),
                    builder: (context, snapshot) {
                      print(snapshot);
                      if (snapshot.hasError) print("Este es el error: ${snapshot.error}");
                      if(snapshot.hasData){
                        print(snapshot.data);
                        return EventsList(list: snapshot.data!);
                      }
                      return Text(" ");
                    },
                  )
              )
            ],
          ),
        )
      );
  }
}

class EventsList extends StatefulWidget {
  final List<EventResource>? list;

  EventsList({Key? key, required this.list,}) : super(key: key);

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {

  var seteventlikes = 0;
  EventService eventservice = EventService();

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.list == null ? 0: widget.list?.length, //events.length
          itemBuilder: (BuildContext context,int index){
            return Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(widget.list![index].artist.realname),
                          SizedBox(width: 10,),
                          Text(widget.list![index].artist.lastname),
                          SizedBox(width: 70,),
                          Text(widget.list![index].eventname)
                        ],
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Text(widget.list![index].eventeescription),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              //Text(widget.list![index].registerdate),
                              IconButton(
                                  onPressed: (){
                                    setState(() {
                                      widget.list![index].eventlikes  += 1;
                                    });
                                    eventservice.updateEvents(widget.list![index].eventlikes, widget.list![index].id);
                                    print('event $index number of likes: '+ widget.list![index].eventlikes.toString()); //${index}  and   ${events[index].likes}
                                  },
                                  icon: Icon(Icons.thumb_up)
                              ),
                              IconButton(
                                  onPressed: (){
                                    setState(() {
                                      widget.list![index].eventlikes -= 1;
                                    });
                                    eventservice.updateEvents(widget.list![index].eventlikes, widget.list![index].id);
                                    print('event $index number of likes: ' + widget.list![index].eventlikes.toString()); //${index} and ${events[index].likes}
                                  },
                                  icon: Icon(Icons.thumb_down)
                              ),
                              SizedBox(width: 20,),
                              Text(widget.list![index].eventlikes.toString()),
                            ],
                          )
                        ],
                      ),
                      isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/imgs/avatar_example.png'),
                      ),
                    )
                )
            );
          }
      );
    }
}


