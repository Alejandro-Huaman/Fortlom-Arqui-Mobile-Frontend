

import 'dart:io';

import 'package:fortloom/domain/entities/ImageResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
class ImagePublicationService{
  var log = Logger();
  var baseUrl = "http://192.168.43.65:8086/api/v1/multimediaservice";

  Future<http.Response> createimageforpublication(int publicationsId,File file) async{


    final response = await http.post(Uri.parse("${baseUrl}/upload/publications/${publicationsId}/images"),
        headers: {"Content-Type": "application/json"}, body: file
    );
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
  Future<List<ImageResource>>getImageByPublicationId(int publicationsId)async{
    final response = await http.get(Uri.parse(baseUrl+"/publications/${publicationsId}/images"));
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





}