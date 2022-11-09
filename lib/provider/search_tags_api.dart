import 'dart:convert';
import 'package:socialoo/global/global.dart';

import 'package:http/http.dart' as http;
import 'package:socialoo/models/search_post_model.dart';

class SearchApi {
  Future<SearchPostModel> searchApi(String text, String? userID) async {
    var responseJson;
    await http.post(Uri.parse('${baseUrl()}/search_post'), body: {
      'text': text,
      'user_id': userID,
    }).then((response) {
      responseJson = _returnResponse(response);
    }).catchError((onError) {
      print(onError);
    });
    return SearchPostModel.fromJson(responseJson);
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        print(response.body);

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
