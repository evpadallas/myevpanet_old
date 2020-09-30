import 'package:flutter/material.dart';
import 'package:myevpanet/main.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myevpanet/domain/api/api.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 35.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CallWindowModal extends StatefulWidget {
  @override
  CallButtonWidget createState() => CallButtonWidget();
}

class CallButtonWidget extends State {
  String phoneToCall = '+79780489664';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Пожалуйста выберите один из номеров технической поддержки.",
                            style: TextStyle(
                                fontSize:
                                    ResponsiveFlutter.of(context).fontSize(2),
                                color: Color.fromRGBO(72, 95, 113, 1.0),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                        ),
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
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone_iphone),
                                      SizedBox(width: 20.0),
                                      Text('+7 (978) 048-96-64')
                                    ],
                                  )

                                  //child: Text('+7 (978) 048-96-64')
                                  ),
                              DropdownMenuItem(
                                  value: '+79780755900',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone_iphone),
                                      SizedBox(width: 20.0),
                                      Text('+7 (978) 075-59-00')
                                    ],
                                  )),
                            ]),
                      ],
                    )),
                SizedBox(height: 24.0),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: Color(0xff374b5d),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0)),
                    ),
                    child: Text(
                      "Совершить звонок",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    if (await canLaunch('tel://$phoneToCall'))
                      launch('tel://$phoneToCall');
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupportMessageModal extends StatefulWidget {
  @override
  SupportMessageModalWidget createState() => SupportMessageModalWidget();
}

class SupportMessageModalWidget extends State {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                  alignment: Alignment.topCenter,
                  child: Center(
                    child: Text(
                      'Отправка сообщения в службу технической поддержки',
                      style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(2),
                          color: Color.fromRGBO(72, 95, 113, 1.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
                    onChanged: (_text) {
                      text = _text;
                    },
                    autofocus: true,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      //hintText: "Напишите нам",
                      labelText: "Ваше сообщение",
                      labelStyle: TextStyle(
                        color: Color(0xff374b5d),
                        letterSpacing: 1,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Color(0xff374b5d),
                          style: BorderStyle.solid,
                        ),
                      ),
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
                SizedBox(height: 24.0),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: Color(0xff374b5d),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0)),
                    ),
                    child: Text(
                      "Отправить сообщение",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    _sendMessagePressed();
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessagePressed() async {
    String answer =
        await RestAPI().remontAddPOST(text, guids[currentGuidIndex], devKey);
    print(answer);
    Navigator.pop(context);
  }
}
