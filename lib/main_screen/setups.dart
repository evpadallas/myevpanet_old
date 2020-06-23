import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/helpers/DesignHelper.dart';
import 'package:myevpanet/push_screen/pushList.dart';
import 'package:myevpanet/webview_screens/pay_widget.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/radio.dart';

class SetupGroup extends StatefulWidget {
  @override
  SetupGroupWidget createState() => SetupGroupWidget();
}

class SetupGroupWidget extends State {

  bool autoState = users[currentGuidIndex]['auto_activation'] == 1 ? true : false;
  bool parentState = users[currentGuidIndex]['flag_parent_control'] == 1 ? true : false;
  String text = '';
  double _currentDays = 1;
  int daysRemain = DateTime.parse(users[currentGuidIndex]["packet_end_utc"]).toUtc().difference(DateTime.now().toUtc()).inDays;
  String daysText = 'день';
  String phoneToCall = '+79780489664';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.light, //navigation bar icons' color
    ));
  }


  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
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
                            'Настройки',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 10.0
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.phone,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                            ),
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
                              _showModalCallSupport();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.face_agent,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                            ),
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
                              _showModalSupport();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    right: 0.0,
                                    left: 32.0
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.bell,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PushScreen()));
                              //_showModalSMSSupport();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                pinned: true,
                expandedHeight: 330,
                flexibleSpace:
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.2,
                              0.7,
                            ],
                            colors: [Color.fromRGBO(68, 98, 124, 1), Color.fromRGBO(15, 34, 51, 1)]
                        )
                    ),
                    child: FlexibleSpaceBar(
                      background: Container(
                        padding: new EdgeInsets.only(top: statusBarHeight + appBarHeight),
                        height: ResponsiveFlutter.of(context).verticalScale(330),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 7.0,
                                            right: 4.0
                                        ),
                                        child: Center(
                                          child: Text("Доступный баланс",
                                            style: TextStyle(
                                              color: Color.fromRGBO(144, 198, 124, 1),
                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  right: 5.0
                                              ),
                                              child: CircleButton(
                                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayView())), // Харитон, тут надо тапнуть на новый скрин пополнения баланса
                                                  iconData: MaterialCommunityIcons.wallet_plus_outline
                                              ),
                                            ),
                                           Text(
                                             NumberFormat('#,##0.00##', 'ru_RU').format(double.parse(userInfo["extra_account"])) + " р.",
                                             //userInfo["extra_account"],
                                             style: TextStyle(
                                               color: double.parse(userInfo["extra_account"]) < 0 ? Color.fromRGBO(255, 81, 105, 1) : Color.fromRGBO(217, 234, 244, 1),
                                               fontSize: ResponsiveFlutter.of(context).fontSize(3.7),
                                               fontWeight: FontWeight.bold,
                                               shadows: [
                                                 Shadow(
                                                   blurRadius: 1.0,
                                                   color: Colors.black,
                                                   offset: Offset(1.0, 1.0),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ],
                                        )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0,
                                            right: 4.0
                                        ),
                                        child: Center(
                                          child: Text(
                                            userInfo["tarif_name"] + " (" + userInfo["tarif_sum"].toString() + " р.)",
                                            style: TextStyle(
                                              color: Color(0xff82a0d7),
                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                )
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.all(30.0),
                                    child: Card(
                                      elevation: 3.0,
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            //border: Border.all(width: 1.0, color: Color.fromRGBO(52, 79, 100, 1.0)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                stops: [
                                                  0.2,
                                                  0.7,
                                                ],
                                                colors: [
                                                  Color.fromRGBO(52, 82, 108, 1.0),
                                                  Color.fromRGBO(28, 49, 70, 1.0)
                                                ]
                                            )
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  //textScaleFactor1.toString(),
                                                  '${userInfo['name']}'.toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(166, 187, 204, 1),
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

                                            ),
                                            Expanded(
                                              flex: 1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.all(5.0),
                                                              child: Text(
                                                                'ID: ' + userInfo['id'].toString(),
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
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
                                                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
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
                                                        )
                                                    ),

                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  0.2,
                                  0.7,
                                ],
                                colors: [Color.fromRGBO(68, 98, 124, 1), Color.fromRGBO(15, 34, 51, 1)]
                            )
                        ),
                      ),
                    ),
                  )
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: 10.0
                      ),
                        child: Column(
                          children: _list1(),
                      ),
                    ),
                    Divider(
                      indent: 20.0,
                      endIndent: 20.0,
                      color: Color(0xff3e6282),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 16.0,
                          left: 16.0,
                          right: 16.0,
                      ),
                      child: Text(
                        'Доступные тарифные планы',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                            color: Color.fromRGBO(72, 95, 113, 1.0),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          right: 16.0,
                          left: 16.0
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 16.0
                        ),
                        child: Column(
                          children: _list(),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 20.0,
                      endIndent: 20.0,
                      color: Color(0xff3e6282),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          right: 16.0,
                          left: 16.0
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 16.0
                        ),
                        child: Column(
                          children: [
                            Text(
                                'Добавление дней к текущему пакету',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                                  color: Color.fromRGBO(72, 95, 113, 1.0),
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 16.0
                              ),
                              child: Text('Стоимость одного дня - ${users[currentGuidIndex]['days_price']} руб.'),
                            ),
                            Text('Текущее количество дней: $daysRemain'),
                            users[currentGuidIndex]['max_days'] > 0 ?
                                Column(
                                  children: <Widget>[
                                    Slider(
                                      value: _currentDays.roundToDouble(),
                                      onChanged: (double days) => setState(() {
                                        _currentDays = days;
                                        if ((days % 10).round() == 0) daysText = 'дней';
                                        if ((days % 10).round() == 1) daysText = 'день';
                                        if ((days % 10).round() >= 2) daysText = 'дня';
                                        if ((days % 10).round() >= 5) daysText = 'дней';
                                        if (days.round() >= 11 && days.round() <= 14) daysText = 'дней';
                                      }),
                                      min: 1,
                                      max: users[currentGuidIndex]['max_days'] >= 1 ? users[currentGuidIndex]['max_days'].toDouble() : 1,
                                      divisions: users[currentGuidIndex]['max_days'],
                                      label: _currentDays.round().toString(),
                                      activeColor: Color(0xff3e6282),
                                      inactiveColor: Color(0xff939faa),
                                    ),
                                    RaisedButton(
                                      onPressed: onAddDaysButtonPressed,
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [Color.fromRGBO(68, 98, 124, 1), Color.fromRGBO(10, 33, 51, 1)]
                                              )
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 64.0,
                                              vertical: 16.0
                                          ),
                                          child: Text(
                                            'Добавить ${_currentDays.round()} $daysText',
                                            style: TextStyle(
                                                fontSize: 18
                                            ),
                                          ),
                                        )//C
                                    )
                                  ],
                                )
                            :
                            Card(
                                color: Colors.cyan,
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'Недостаточно средств для добавления дней.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
        ],
      ),
     ),
   );
  }

  void onAddDaysButtonPressed() async {
    String answer = await RestAPI().addDaysPUT(_currentDays.round(), guids[currentGuidIndex], devKey);
    if (!answer.startsWith('is')) {
      var decode = json.decode(answer);
      print(decode);
      var result = await RestAPI().userDataGet(guids[currentGuidIndex], devKey);
      //users[currentGuidIndex]['extra_account'] = decode['message']['extra_account'].toString();
      //users[currentGuidIndex]['packet_secs'] = decode['message']['packet_secs'];
      userInfo = users[currentGuidIndex];
      setState(() {daysRemain += _currentDays.round();});
    }
  }
  void onSetupAutoChange(value) async{
    String answer = await RestAPI().switchChangePUT('activation', guids[currentGuidIndex], devKey);
    setState(
      () {
        if (answer.startsWith('is')) {
          users[currentGuidIndex]['auto_activation'] = value ? '0' : '1';
        } else {
          users[currentGuidIndex]['auto_activation'] = answer;
        }
        userInfo = users[currentGuidIndex];
      }
    );
  }

  void onSetupParentChange(bool value) async{
    String answer = await RestAPI().switchChangePUT('parent', guids[currentGuidIndex], devKey);
    setState(
      () {
        if (answer.startsWith('is')) {
          users[currentGuidIndex]['flag_parent_control'] = value ? '0' : '1';
        } else {
          users[currentGuidIndex]['flag_parent_control'] = answer;
        }
      userInfo = users[currentGuidIndex];
      }
    );
  }

  // это можно вынести в отдельный файл
  /*
  * Вызов модального окна с сообщением в ремонты
  * */
  void _showModalSupport() async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SupportMessageModal()
          );
        }
    );
  }
  /*
  *  Вызов модального окна для совершения звонка
  * */
  void _showModalCallSupport() async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: CallWindowModal()
          );
        }
    );
  }

  final double appBarHeight = 66.0;

  List<Widget> _list1() {
    List<Widget> tList = [];
    tList.add(
      SwitchListTile(
        activeColor: Color(0xff3e6282),
        dense: true,
        value: users[currentGuidIndex]['auto_activation'] == '1' ? true : false,
        title: Text('Автоактивация пакета'),
        onChanged: (bool state) {onSetupAutoChange(state);},
      )
    );
    tList.add(
      SwitchListTile(
        activeColor: Color(0xff3e6282),
        dense: true,
        value: users[currentGuidIndex]['flag_parent_control'] == '1' ? true : false,
        title: Text('Родительский контроль'),
        onChanged: (bool state) {onSetupParentChange(state);},
      )
    );
    return tList;
  }

  // доступные тарифные планы
  List<Widget> _list() {
    List<Widget> tList = [];
      tList.add(
          RadioGroup()
      );
    return tList;
  }

}
