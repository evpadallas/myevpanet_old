import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import '../../main.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class PushScreen extends StatefulWidget {
  PushScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PushScreenState createState() => _PushScreenState();
}

class _PushScreenState extends State<PushScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff32506a), title: Text('Мои уведомления')),
      body: ListView(children: listRows()),
      /*bottomSheet: FlatButton(
        onPressed: () async{
          Clipboard.setData(
            ClipboardData(
              text: devKey.toString()
            )
          );
          //final shared = await SharedPreferences.getInstance();
          //sharedPushes.add(devKey.toString());
          //shared.setStringList('pushes', sharedPushes);
        },
        child: Text('Скопировать ключ в память'),
      )*/
    );
  }

  List<Widget> listRows() {
    List<Widget> _list = [];
    //print('Reading content of pushes.dat');
    /*for (var item in sharedPushes) {
      _list.add(Text(item));
    }*/
    for (var _push in pushes) {
      //print(_push);
      _list.add(
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: CustomListItemTwo(
            thumbnail: Container(
              decoration: const BoxDecoration(
                  color: Color(0xff42617e), shape: BoxShape.circle),
              alignment: Alignment(0.0, 0.0),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            title: "ID: " + _push['id'].toString(),
            subtitle: _push['body'],
            author: _push['title'],
            publishDate: _push['date'].toString(),
            //readDuration: '12 mins',
          ),
        ),
      );
      _list.add(Divider());
    }
    return _list;
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.6,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  //readDuration: readDuration,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate ★',
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
