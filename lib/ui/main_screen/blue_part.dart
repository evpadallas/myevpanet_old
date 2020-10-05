import 'package:flutter/material.dart';
import 'package:myevpanet/model/api/api.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/ui/main_screen/radio.dart';
import 'package:myevpanet/ui/main_screen/setups.dart';

String sendText;

Widget blueZone_1(Map userInfo) {
  return Container(
    color: Colors.blue,
    height: 230.0,
    child: Padding(
      padding:
          EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Текущий тарифный план",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                userInfo["tarif_name"] +
                                    " (" +
                                    userInfo["tarif_sum"].toString() +
                                    " р.)",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    //Text('ID: ${userInfo['id'].toString()}'),
                    //Text('Тарифный план: ' + userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
                  ],
                )),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                          //top: 20.0
                          ),
                      child: SizedBox(
                        /*height: 165,
                          width: 165,*/
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              child: CircularProgressIndicator(
                                value: 1,
                                valueColor:
                                    new AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 7.0,
                              ),
                              height: 100.0,
                              width: 100.0,
                            ),
                            SizedBox(
                              child: CircularProgressIndicator(
                                value: secToDate(userInfo['packet_secs']) / 30,
                                //value: 0.875,
                                valueColor: new AlwaysStoppedAnimation(
                                    Colors.lightBlueAccent),
                                strokeWidth: 5.0,
                              ),
                              height: 100.0,
                              width: 100.0,
                            ),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "Осталось",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          // Stroked text as border.
                                          Text(
                                            "${secToDate(userInfo['packet_secs']).truncate()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                foreground: Paint()
                                                  ..style = PaintingStyle.stroke
                                                  ..color = Colors.white70
                                                  ..strokeWidth = 1),
                                          ),
                                          Text(
                                            "${secToDate(userInfo['packet_secs']).truncate()}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.lightGreenAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "дней",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              height: 100.0,
                              width: 100.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.0, right: 4.0),
                          child: Text(
                            "На Вашем счету: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          userInfo["extra_account"].toString() + " р.",
                          style: TextStyle(
                            color: double.parse(userInfo["extra_account"]) < 0
                                ? Colors.pink
                                : Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Text("${ 1 - secToDate(userInfo['packet_secs']/30)}"),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget blueZone_2(Map userInfo) {
  return Container(
      child: Column(
    children: <Widget>[
      double.parse(userInfo["debt"]) > 0
          ? Container(
              decoration: new BoxDecoration(color: Colors.red),
              child: new ListTile(
                title: Text(
                  "За вами числится задолженость " +
                      userInfo["debt"]?.toString() +
                      " р.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                //subtitle: Text(userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
              ))
          : Container(),
    ],
  ));
}

Widget blueZoneT(Map userInfo) {
  return RadioGroup();
}

Widget blueZoneS(Map userInfo) {
  return SetupGroup();
}

Widget blueZoneM() {
  print(userInfo.toString());
  return Padding(
      padding: EdgeInsets.all(16.0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        /*Center(
            child: Text('Сообщение в службу поддержки:')
          ),*/
        Center(
          child: TextField(
            maxLines: 4,
            //inputFormatters: [phone],
            keyboardType: TextInputType.multiline,
            onChanged: (String text) {
              sendText = text;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите текст сообщения'),
          ),
        ),
        Center(
            child: RaisedButton(
                onPressed: sendMessagePressed,
                child: Text('Отправить в службу поддержки')))
      ]));
}

void sendMessagePressed() async {
  String _url = 'https://app.evpanet.com/?set=add_request';
  _url += '&guid=${guids[currentGuidIndex]}';
  _url += '&devid=$devKey';
  _url += '&comment=$sendText';
  print('Sending [$sendText] to support by URL: $_url');
  dynamic answer = await RestAPI().getData(_url);
  print('$answer');
}

double secToDate(secsLeft) {
  return secsLeft / 60 / 60 / 24;
}
