import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ItemCard.dart';

class ListAnmie extends StatelessWidget {
  const ListAnmie({Key key, this.urlPath}) : super(key: key);

  final String urlPath;

  Future<List<dynamic>> getAnmie(String imagePath) async {
    String api = "https://api.trace.moe/search?anilistInfo&url=";
    String url = api + imagePath;

    var result = await http.get(url);

    return json.decode(result.body)['result'];
  }

  String _getfilName(dynamic anmie) {
    return anmie['filename'];
  }

  String _getName(dynamic anime) {
    return anime['anilist']['title']['english'];
  }

  String _getimage(Map<dynamic, dynamic> anmie) {
    return anmie['image'].toString();
  }

  String _getvideo(Map<dynamic, dynamic> anmie) {
    return anmie['video'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: getAnmie(urlPath),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(_getimage(snapshot.data[0]));
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemCard(
                    imgUrl: _getimage(snapshot.data[index]),
                    name: _getName(snapshot.data[index]),
                    filName: _getfilName(snapshot.data[index]),
                    video: _getvideo(snapshot.data[index]),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
