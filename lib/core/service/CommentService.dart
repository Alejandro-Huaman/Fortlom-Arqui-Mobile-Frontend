import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/CommentResource.dart';
import 'package:fortloom/domain/entities/PostResource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

String currentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}

class CommentService {
  // var baseUrl = "http://192.168.0.102:8080/api/v1/publications/{publicationId}/comments";
  var log = Logger();

  Future<List<Comment>> getallByPostId(int postId) async {
    final response = await http.get(Uri.parse(
        "http://192.168.0.102:8080/api/v1/publications/${postId}/comments"));
    List<Comment> lstComments = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);

    for (var item in jsonData["content"]) {
      Comment comment = Comment(item["id"], item["commentdescription"],
          item["registerdate"], item["person"], item["publication"]);

      lstComments.add(comment);
    }

    return lstComments;
  }

  Future<http.Response> addComment(
      String commentdescription, int publicationId, int userId) async {
    Map data = {
      'commentdescription': '$commentdescription',
      'registerdate': currentDate(),
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "http://192.168.0.102:8080/api/v1/users/${userId}/publications/${publicationId}/comments"),
        headers: {"Content-Type": "application/json"},
        body: body);
    return response;
  }

  // Future<http.Response> addPost(
  //     String name, String description, int artistId) async {
  //   Map data = {
  //     'publicationName': '$name',
  //     'publicationdescription': '$description',
  //     'likes': 0,
  //   };
  //   var body = json.encode(data);
  //   final response = await http.post(
  //       Uri.parse(
  //           "http://192.168.0.102:8080/api/v1/artists/${artistId}/publications"),
  //       headers: {"Content-Type": "application/json"},
  //       body: body);
  //   log.i(response.body);
  //   log.i(response.statusCode);

  //   return response;
  // }

}
