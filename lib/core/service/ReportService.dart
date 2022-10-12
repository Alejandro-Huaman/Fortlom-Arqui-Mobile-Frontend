import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ReportService {
  var log = Logger();

  Future<int> createreport(
      String reportDescription, int usermainId, int UserReported) async {
    var usermainIdstring = usermainId.toString();
    var userReported = UserReported.toString();

    Map data = {
      'reportDescription': '$reportDescription',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "http://192.168.0.102:8080/api/v1/usersmains/$usermainIdstring/usersreports/$userReported/reports"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    int number = response.statusCode;
    print(number);
    return number;
  }
}
