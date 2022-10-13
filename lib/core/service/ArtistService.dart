import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';


class ArtistService {
  var log=Logger();
  var baseUrl = "http://192.168.1.28:8080/api/v1";
  Future<List<ArtistResource>> getallArtists() async{
    final response = await http.get(Uri.parse(baseUrl + "/artists"));
    List<ArtistResource>artists=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){
      String variable;
      if(item["content"] == null) {
        variable = "https://www.pngkey.com/png/full/90-904040_logo-rockstar-black-and-white-logo.png";
      }
      else {
        variable = item["content"];
      }
      ArtistResource artistResource= new ArtistResource(item["id"],
          item["username"] ,item["realname"] ,item["lastname"] ,
          item["email"], item["password"],variable, item["artistfollowers"], item["instagramLink"],
          item["facebookLink"], item["twitterLink"]);

      artists.add(artistResource);
    }
    return artists;
  }


  Future<http.Response> updateArtist(int artistfollowers,int artistId) async{
    Map data ={
      'artistfollowers': '$artistfollowers'
    };
    var body = json.encode(data);
    final response = await http.put(Uri.parse(baseUrl + "/artists/"+artistId.toString()),
        headers: {"Content-Type": "application/json"}, body: body);
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }
}