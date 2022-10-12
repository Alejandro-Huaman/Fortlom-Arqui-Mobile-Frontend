import 'package:fortloom/domain/entities/CreateForumResource.dart';
import 'package:fortloom/domain/entities/ForumResource.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
class ForumService {

  var baseUrl="http://192.168.1.28:8080/api/v1/forums";
  var log=Logger();
  Future<List<ForumResource>> getall() async
  {
      final response = await http.get(Uri.parse("http://192.168.1.45:8080/api/v1/forums"));
      List<ForumResource>forums=[];
      log.i(response.body);
      log.i(response.statusCode);
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["content"]){
            PersonResource personResource= new PersonResource(item["person"]["id"],item["person"]["username"] ,item["person"]["realname"] ,item["person"]["lastname"] ,
                item["person"]["email"], item["person"]["password"]);
            ForumResource forumResource = new ForumResource(item["id"],item["forumname"],item["forumdescription"] , personResource);
            
           forums.add(forumResource);

      }

      return forums;

  }

  Future<http.Response> addForum(String name,String description,int userID) async{
       Map data ={
         'forumname': '$name',
         'forumdescription': '$description',
       };
       var body = json.encode(data);
       final response = await http.post(Uri.parse("http://192.168.1.28:8080/api/v1/user/"+userID.toString()+"/forums"),
           headers: {"Content-Type": "application/json"}, body: body
       );
       log.i(response.body);
       log.i(response.statusCode);

       return response;
  }


}