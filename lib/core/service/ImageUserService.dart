




import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

import '../../domain/entities/ImageResource.dart';
class ImageUserService{

  var log = Logger();
  var baseUrl = "http://192.168.0.201:8086/api/v1/multimediaservice";


  Future<http.Response> createimageforuser(int userId,File file) async{


    final response = await http.post(Uri.parse("${baseUrl}/upload/users/${userId}/images"),
        headers: {"Content-Type": "application/json"}, body: file
    );
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
  Future<List<ImageResource>>getImageByUserId(int publicationsId)async{
    final response = await http.get(Uri.parse(baseUrl+"/users/${publicationsId}/images"));
    List<ImageResource> lstPosts = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {

      ImageResource imageResource=ImageResource(item["id"], item["imagenUrl"], item["userid"], item["imagenId"], item["publicationid"]);
      lstPosts.add(imageResource);

    }
    return lstPosts;
  }
  Future<http.Response>delete(int id)async{
    final response = await http.get(Uri.parse(baseUrl+"/delete/${id}"));
    log.i(response.body);
    log.i(response.statusCode);
    return response;

  }





}