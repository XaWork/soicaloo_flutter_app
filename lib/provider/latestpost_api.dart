import 'dart:convert';

import 'package:socialoo/global/global.dart';
import 'package:socialoo/models/latest_model.dart';

import 'package:http/http.dart' as http;

class LatestPostApi {
  Future<LatestPostModel> latestPostApi(String? userID) async {
    var responseJson;
    await http.post(Uri.parse('${baseUrl()}/get_all_latest_post'), body: {
      'user_id': userID,
    }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return LatestPostModel.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);

        return responseJson;
      case 400:
        throw Exception(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw Exception(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
