import 'package:flutter/material.dart';
import 'package:flutter_anmie_discover/OpenVideo.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key key, this.imgUrl, this.name, this.filName, this.video})
      : super(key: key);

  final String imgUrl;
  final String filName;
  final String name;
  final String video;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Expanded(
                  child: Image.network(
                    imgUrl,
                  ),
                  flex: 2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        title: Text(name ?? ''),
                        subtitle: Text(filName ?? ''),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text("PLAY"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpenVideo(
                                          videoPath: video,
                                        )),
                              );
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              flex: 8,
            ),
          ],
        ),
      ),
      elevation: 8,
      margin: EdgeInsets.all(10),
    );
  }
}
