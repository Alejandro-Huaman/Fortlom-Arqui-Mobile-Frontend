import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProfileService {
  Future<http.Response> editProfile(int id, String realnameController,
      String lastnameController, String emailController, String passwordController) async {
    var baseUrl = 'http://192.168.1.45:8080/api/v1/users/changeprofile/$id';
    var log=Logger();

    print(id);
    print(realnameController);
    print(lastnameController);
    print(emailController);
    print(passwordController);


    Map data = {
      'realname': '$realnameController',
      'lastname': '$lastnameController',
      'email': '$emailController',
      'password': '$passwordController',

    };
    var body = json.encode(data);
    var idString = id.toString();
    final response = await http.put(Uri.parse("http://192.168.68.115:8080/api/v1/users/changeprofile/$idString"),
        headers: {"Content-Type": "application/json"}, body: body
    );
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
}
