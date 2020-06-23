import 'dart:ui';
import 'package:myevpanet/helpers/DesignHelper.dart';
//import 'package:myevpanet/payment_screen/paymaster.dart';
import 'package:myevpanet/push_screen/pushList.dart';
import 'package:myevpanet/webview_screens/pay_widget.dart';
import 'package:myevpanet/widgets/drawer.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myevpanet/main_screen/setups.dart';


class MainScreenWidget extends StatefulWidget {
  
  MainScreenWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {

  String text = '';
  String phoneToCall = '+79780489664';
  DateFormat dateFormat;

  @override
  void initState() {
    if (verbose >= 1) print('MainScreen initState()');
    if (verbose >= 1) print('Start getData');
    getData();
    super.initState();
    //fbHelper.configure(this.context);
    if (verbose >= 1) print('End getData');
    Intl.defaultLocale = 'ru_RU';
    initializeDateFormatting();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icons' color
    ));

  }
  void getData() async {
    await UserInfo().getUserData();
    setState(() {});
    if (verbose >= 5) print('Main Screen: Show UserInfo:\n$userInfo');
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(245, 246, 248, 1.0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // here the desired height
        child: AppBar(
            iconTheme: new IconThemeData(
                color: Color.fromRGBO(72, 95, 113, 1.0)
            ),
            titleSpacing: 0.0,
            brightness: Brightness.light,
            backgroundColor: Color.fromRGBO(245, 246, 248, 1.0),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Информация",
                  style: TextStyle(
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      fontSize: 24.0
                  ),
                ),
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(
                      color: Color.fromRGBO(146, 152, 166, 1.0),
                      fontSize: 14.0
                  ),
                )
              ],
            ),              // Your widgets here
            elevation: 0.0,
            actions: <Widget>[
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 10.0
                    ),
                    child: Icon(
                      MaterialCommunityIcons.phone,
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      size: 24.0,
                    )
                ),
                onTap: () {
                  _showModalCallSupport();
                },
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0
                    ),
                    child: Icon(
                      MaterialCommunityIcons.face_agent,
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      size: 24.0,
                    )
                ),
                onTap: () {
                  _showModalSupport();
                },
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 16.0,
                        left: 16.0
                    ),
                    child: Icon(
                      MaterialCommunityIcons.bell,
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      size: 24.0,
                    )
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PushScreen()));
                },
              ),
            ],
        ),
      ),
      body: Column(
        children: [
          // каруселька
          Container(
            child: CarouselSlider(
              items: idList(),
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 16/10,
              viewportFraction: 0.85,
              onPageChanged: (index) {
                currentGuidIndex = index;
                userInfo = users[currentGuidIndex];
                _current = index;
                setState(() {});
              },
            ),
          ),
          // навигационные точечки
          Container(
            //padding: EdgeInsets.all(5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: idListPoints()
            ),
          ),
          // секция с картами деталей учетной записи
          Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.only(
                top: 0.0,
                left: 30.0,
                right: 30.0
              ),
              children: <Widget> [
                // виджет отображения долга
                Container(
                    child: Column(
                      children: <Widget>[
                        double.parse(users[currentGuidIndex]["debt"]) > 0
                            ?
                            Card(
                                color: Colors.red,
                                child: new ListTile(
                                      title: Text(
                                        "За Вашей учётной записью числится задолженость ${users[currentGuidIndex]["debt"].toString()} р.",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                )
                            )
                            :
                        Container(),
                      ],
                    )
                ),
                // текст - Детали учетной записи
                Container(
                  padding: EdgeInsets.only(
                    left: 40.0,
                    top: 10.0,
                    bottom: 10.0
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Детали учётной записи',
                    style: TextStyle(
                      fontSize: ResponsiveFlutter.of(context).fontSize(2.7),
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 5.0),
                  child: Card(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.album, size: 40),
                              title: Text('Тарифный план'),
                              subtitle: Text(
                                  '${users[currentGuidIndex]["tarif_name"]} (${users[currentGuidIndex]["tarif_sum"].toString()} р.)'
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 5.0),
                  child: Card(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.album, size: 40),
                              title: Text('IP адрес абонента'),
                              subtitle: Text(users[currentGuidIndex]["real_ip"]),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 5.0),
                  child: Card(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.album, size: 40),
                              title: Text('Адрес подключения'),
                              subtitle: Text(users[currentGuidIndex]["street"] + ", д. " + users[currentGuidIndex]["house"] + ", кв. " + users[currentGuidIndex]["flat"]),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
  // генерируем точки
  List<Widget> idListPoints() {
    List<Widget> _list = [];
    for (var item = 0; item < guids.length; item++/*users.keys*/) {
      _list.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == item
                  ? Color.fromRGBO(116, 162, 177, 1.0)
                  : Color.fromRGBO(198, 209, 216, 1.0)
          ),
        )
      );
    }
    return _list;
  }
  // список тёмных плашек
  List<Widget> idList() {
    List<Widget> _list = [];
    for (var item = 0; item < guids.length; item++/*users.keys*/) {
      var now = DateTime.now().toUtc();
      var packet = DateTime.parse(users[item]["packet_end_utc"]).toUtc();
      var daysRemain = packet.difference(now).inDays;

      var packetEndColor = Colors.white;

      if (daysRemain > 0 && daysRemain < 1) {
       packetEndColor = Colors.amber;
      }
      else if (daysRemain <= 0) {
       packetEndColor = Colors.red;
      }

        _list.add(
          GestureDetector(
            onTap: () async{
              print('!!!!!!!!! current index is: $currentGuidIndex');
              await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SetupGroup()));
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.only(
                  top: 0.0,
                  left: 5.0,
                  right: 5.0,
                  bottom: 0.0
              ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Color.fromRGBO(52, 79, 100, 1.0)),
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).moderateScale(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(184, 202, 220, 1.0),
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          1.0, // Move to right 10  horizontally
                          2.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          0.2,
                          1.0,
                        ],
                        colors: [Color.fromRGBO(68, 98, 124, 1), Color.fromRGBO(10, 33, 51, 1)]
                    )
                  ),
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                // Левая сторона верхнего блока
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        'ID: ' + users[item]['id'].toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ResponsiveFlutter.of(context).fontSize(2.4),
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
                                    ),
                                    _current == _current/*item*/ ?
                                    CircleButton(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayView()));
                                      },
                                      iconData: MaterialCommunityIcons.wallet_plus_outline
                                    ): Text(''),
                                  ],
                                ),
                              ),
                              Expanded(
                                // Правая сторона верхнего блока
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.0),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 3.0,
                                          right: 4.0
                                      ),
                                      child: Text("Доступный баланс",
                                        style: TextStyle(
                                          color: Color.fromRGBO(144, 198, 124, 1),
                                          fontSize: ResponsiveFlutter.of(context).fontSize(1.6),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      NumberFormat('#,##0.00##', 'ru_RU').format(double.parse(users[item]["extra_account"])) + " р.",
                                      //userInfo["extra_account"],
                                      style: TextStyle(
                                        color: double.parse(users[item]["extra_account"]) < 0 ? Color.fromRGBO(255, 81, 105, 1) : Colors.white,
                                        fontSize: ResponsiveFlutter.of(context).fontSize(3.2),
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
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  top: 0.0
                                ),
                                  child: Text(
                                    //textScaleFactor1.toString(),
                                    '${users[item]['name']}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: ResponsiveFlutter.of(context).fontSize(3),
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
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                        'Окончание действия пакета',
                                        style: TextStyle(
                                          fontSize: ResponsiveFlutter.of(context).fontSize(1.4),
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.black,
                                              offset: Offset(1.0, 1.0),
                                            ),
                                          ],
                                        ),
                                    ),
                                    Text(
                                      userInfo["packet_end"] + " (" + daysRemain.toString() + " дн.)",
                                        style: TextStyle(
                                          fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                          fontWeight: FontWeight.bold,
                                          color: packetEndColor,
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
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0
                                      ),
                                      child: Icon(
                                        MaterialCommunityIcons.cogs,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            )
          )
        );
    }
    return _list;
  }

  // Вызов модального окна с сообщением в ремонты
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
  //  Вызов модального окна для совершения звонка
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

}




