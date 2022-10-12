import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';


class FollowService {
  var log=Logger();
  var baseUrl = "http://192.168.1.45:8080/api/v1";

  Future<http.Response> createFollow(int artistId, int fanaticId) async{
    final response = await http.post(Uri.parse(baseUrl + "fanatics/" + fanaticId.toString() + "/artists/" + artistId.toString() + "/follows"));
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }
}