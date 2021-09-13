import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_anmie_discover/beauty_textField.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ListAnmie.dart';
import 'package:image_picker/image_picker.dart';
//import 'api.dart' as api;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discover Anmie App ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Discover Anmie App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      //headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController imageUrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MyCustomForm(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Discover Anime App')),
            ListTile(
              title: const Text('@GeeSuth'),
              onTap: () {
                _launchInBrowser('https://twitter.com/GeeSuth');
              },
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyCustomForm extends StatelessWidget {
  MyCustomForm({Key key}) : super(key: key);

  String _url = "";
  void urlChange(String url) {
    print(url);
    _url = url;
  }

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          BeautyTextfield(
            width: double.maxFinite,
            height: 60,
            backgroundColor: Colors.grey,
            prefixIcon: Icon(Icons.create),
            placeholder: 'Enter Image Path',
            suffixIcon: Icon(Icons.search_rounded),
            controller: _controller,
            onClickSuffix: () {
              urlChange(_controller.text);
              (context as Element).markNeedsBuild();
            },
            inputType: TextInputType.text,
            onSubmitted: (data) {
              urlChange(data);
              (context as Element).markNeedsBuild();
            },
          ),
          TextButton(
              onPressed: () {
                _showPicker(context);
              },
              child: new Text('Upload')),
          _url == ""
              ? new Text('Please Input The path || upload Comming Soon..')
              : Expanded(
                  child: ListAnmie(
                  urlPath: _url,
                ))
          //ListAnmie()
        ],
      ),
    );
  }

  Future<List<dynamic>> getAnmieByImage(File file) async {
    var base64Image = base64Encode(snapshot.data.readAsBytesSync());
    String url = "https://api.trace.moe/search";
    var result = await http.post(url, body: file);
    return json.decode(result.body)['result'];
  }

  _imgFromGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (image == null) {
      print('nulled value');
    } else {
      print(await getAnmieByImage(image));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }
}
