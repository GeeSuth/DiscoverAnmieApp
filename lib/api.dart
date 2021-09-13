import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  Future<List<dynamic>> getAnmie(String imagePath) async {
    String api = "";
    String url = api + imagePath;
    var result = await http.get(url);
    return json.decode(result.body)['result'];
  }

  Future<List<dynamic>> getAnmieByImage(File file) async {
    String url = "https://api.trace.moe/search";
    var result = await http.post(url, body: file);
    return json.decode(result.body)['result'];
  }
}
