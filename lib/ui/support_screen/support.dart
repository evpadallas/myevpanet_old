import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet/model/api/api.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:myevpanet/main.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  SupportScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  String text = '';
  String phoneToCall = '+79780489664';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 66.0;
    return Container(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Оставить сообщение',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
                expandedHeight: 170,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [
                        0.2,
                        0.7,
                      ],
                          colors: [
                        Color.fromRGBO(68, 98, 124, 1),
                        Color.fromRGBO(15, 34, 51, 1)
                      ])),
                  child: FlexibleSpaceBar(
                    background: Container(
                      padding: new EdgeInsets.only(top: appBarHeight + 10.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                            0.2,
                            0.7,
                          ],
                              colors: [
                            Color.fromRGBO(68, 98, 124, 1),
                            Color.fromRGBO(15, 34, 51, 1)
                          ])),
                      child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Ф.И.О.: ' + userInfo['name'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.5),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Ваш ID: ' + userInfo['id'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.5),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Логин: ' + userInfo['login'].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveFlutter.of(context)
                                        .fontSize(1.5),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                )),
            new SliverList(
                delegate: new SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: TextField(
                            onChanged: (_text) {
                              text = _text;
                            },
                            maxLines: 3,
                            //inputFormatters: [phone],
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              //hintText: "Напишите нам",
                              labelText: "Ваше сообщение",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.amber,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                            child: RaisedButton(
                                onPressed: sendMessagePressed,
                                child: Text('Отправить в службу поддержки'))),
                        Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                    "Вы так же можете связаться со службой поддержки одним из следующих способов:"),
                                DropdownButton<String>(
                                    value: phoneToCall,
                                    autofocus: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        phoneToCall = newValue;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          value: '+79780489664',
                                          child: Text('+7(978)048-96-64')),
                                      DropdownMenuItem(
                                          value: '+79780755900',
                                          child: Text('+7(978)075-59-00')),
                                    ]),
                                SizedBox.fromSize(
                                  size: Size(56, 56), // button width and height
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.orange, // button color
                                      child: InkWell(
                                        splashColor:
                                            Colors.green, // splash color
                                        onTap: () async {
                                          if (await canLaunch(
                                              'tel://$phoneToCall'))
                                            launch('tel://$phoneToCall');
                                        }, // button pressed
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.call), // icon
                                            Text("Call"), // text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ]),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  void sendMessagePressed() async {
    String answer =
        await RestAPI().remontAddPOST(text, guids[currentGuidIndex], devKey);
    print(answer);
    Navigator.pop(context);
  }
}
