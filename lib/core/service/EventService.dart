import 'package:fortloom/domain/entities/CreateEventResource.dart';
import 'package:fortloom/domain/entities/EventResource.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class EventService{

  var baseUrl = "http://192.168.1.45:8080/api/v1";
  var log = Logger();

  Future<List<EventResource>> getallEvents() async{
    final response = await http.get(Uri.parse(baseUrl + "/events"));
    List<EventResource>events=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){
      ArtistResource artistResource= new ArtistResource(item["artist"]["id"],item["artist"]["username"] ,item["artist"]["realname"] ,item["artist"]["lastname"] ,
          item["artist"]["email"], item["artist"]["password"],item["artist"]["content"], item["artist"]["artistfollowers"], item["artist"]["instagramLink"],
          item["artist"]["facebookLink"], item["artist"]["twitterLink"]);

      print(artistResource);

      EventResource eventResource = new EventResource(item["id"],item["eventname"],item["eventeescription"] , item["eventlikes"],item["registerdate"], artistResource);


      events.add(eventResource);
    }
    print(events);
    return events;
  }

  Future<http.Response> addEvents(String eventName, String eventDescription, int eventLikes, String registerDate, int ArtistId) async {
    Map data ={
      'eventname': '$eventName',
      'eventeescription': '$eventDescription',
      'eventlikes': '$eventLikes',
      'registerdate': '$registerDate'
    };
    var body = json.encode(data);
    final response = await http.post(Uri.parse(baseUrl + "/artist/"+ArtistId.toString()+"/events"),
        headers: {"Content-Type": "application/json"}, body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> updateEvents(int eventLikes,int EventId) async{
    Map data ={
      'eventlikes': '$eventLikes'
    };

    var body = json.encode(data);
    final response = await http.put(Uri.parse(baseUrl + "/event/"+EventId.toString()),
        headers: {"Content-Type": "application/json"}, body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;

  }


}

