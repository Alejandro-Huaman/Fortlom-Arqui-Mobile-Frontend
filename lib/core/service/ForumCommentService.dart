
import 'package:fortloom/domain/entities/ForumCommentResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

import '../../domain/entities/ForumResource.dart';
import '../../domain/entities/PersonResource.dart';

class ForumCommentService{

var baseUrl="http://localhost:8080/api/v1/forums/{{forumId}}/forumcomments";
var log=Logger();

Future<List<ForumCommentResource>> getbyForumID(int id) async
{
  final response = await http.get(Uri.parse("http://192.168.1.45:8080/api/v1/forums/"+id.toString()+"/forumcomments"));
  List<ForumCommentResource>comments=[];
  log.i(response.body);
  log.i(response.statusCode);
  String body = utf8.decode(response.bodyBytes);
  final jsonData = jsonDecode(body);
  for (var item in jsonData["content"]){

        PersonResource personResource= new PersonResource(item["person"]["id"],item["person"]["username"] ,item["person"]["realname"] ,item["person"]["lastname"] ,
        item["person"]["email"], item["person"]["password"]);
        PersonResource personResourcefroforum= new PersonResource(item["forum"]["person"]["id"],item["forum"]["person"]["username"] ,item["forum"]["person"]["realname"] ,item["forum"]["person"]["lastname"] ,
            item["forum"]["person"]["email"], item["forum"]["person"]["password"]);
        ForumResource forumResource = new ForumResource(item["forum"]["id"],item["forum"]["forumname"],item["forum"]["forumdescription"] , personResourcefroforum);
        ForumCommentResource forumCommentResource= new ForumCommentResource(item["id"],item["commentdescription"] ,item["registerdate"] , personResource, forumResource);
        comments.add(forumCommentResource);

  }

  return comments;
}

Future<http.Response> addForumComment(String commentdescription,int id,int personid) async{
  Map data ={
    'commentdescription': '$commentdescription',

  };
  var body = json.encode(data);
  final response = await http.post(Uri.parse("http://192.168.0.201:8080/api/v1/users/"+personid.toString()+"/forums/"+id.toString()+"/forumcomments"),
      headers: {"Content-Type": "application/json"}, body: body
  );
  log.i(response.body);
  log.i(response.statusCode);

  return response;
}



}