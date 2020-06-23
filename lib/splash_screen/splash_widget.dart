import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myevpanet/helpers/firebase_helper.dart';
import 'package:myevpanet/main.dart';
import 'dart:io';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main_screen/main_widget.dart';
import 'package:myevpanet/login_screen/login_widget.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  @override
  initState() {
    if (verbose >=1) print('SplashScreen initState');
    super.initState();
    //fbHelper = FirebaseHelper();
    whereToGo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  goGo(int index) async {
    Timer(Duration(seconds: 2), await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => index == 1 ? MainScreenWidget() : LoginWidget())));
  }
  int guidsNumber = guids.isEmpty ? 1 : guids.length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff11273c),
                      Color(0xff3c5d7c)
                    ]
                )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                              child: Image.asset("assets/images/splash_logo.png"),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0,
                          left: 24.0,
                        right: 24.0,
                        bottom: 16.0
                      ),
                      child: LinearProgressIndicator(
                          value: currentGuidIndex / guidsNumber,
                          backgroundColor: Color(0xff3c5d7c),
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                      ),
                    ),
                    Text(
                      "Загрузка...",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white
                      ),
                    ),

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void whereToGo() async {
    final file = await FileStorage('key.dat').localFile;
    if (file.existsSync()) {
      if (verbose >=1) print('Key file is exists');
      devKey = file.readAsStringSync(encoding: utf8);
      if (devKey.toString().length > 7) {
        if (verbose >=1) print('Device key from file is: $devKey');
        //пробуем обновить токен гугла
        FirebaseHelper().getAppToken().then((String value) {
          if (value == null) {
            print('we got null token from google');
          } else {
            print('new token from google is: $value');
            if (value != devKey) {
              print('token has changed. we have to go to new registration');
              file.writeAsStringSync(value, mode: FileMode.write, encoding: utf8);
              goGo(0);
            }
          }
        });
        //guidlist.dat file check
        //загрузка списка ГУИДОВ из файла
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        if (_guidsfile.existsSync()) {
          if (verbose >=1) print('GUIDs file exists');
          var _readResult = _guidsfile.readAsStringSync(encoding: utf8);
          final parsed = jsonDecode(_readResult);
          //json.decode(_readResult);
          if (verbose >=1) print(parsed);
          guids = parsed;//['message']['guids'];
          if (verbose >=1) print('List of GUIDS readed. Updating UserInfo from Server');
          currentGuidIndex = 0;
          //есть список гуидов и есть токен.
          //можно обновить данные с сервера или если не получится считать из файлов
          guidsNumber = guids.length;
          for (var guid in guids) {
            if (verbose >=1) print('Updating from Server for guid $guid');
            var result = await RestAPI().userDataGet(guid, devKey);
            if (result == 'Ok') {
              if (verbose >=1) print('Ok. File $guid.dat and users[$currentGuidIndex] updated');
            } else {
              if (verbose >=1) print('Not ok!');
              if (verbose >=1) print('Trying to read from file instead');
              await UserInfo().readFromFile();
            }
            currentGuidIndex++;
            setState(() {});
          }
          currentGuidIndex = 0;
          //загрузка пушей
          final shared = await SharedPreferences.getInstance();
          sharedPushes = shared.getStringList('pushes') ?? [];
          print(sharedPushes);
          sharedPushes.forEach((element) {pushes.add(jsonDecode(element));});
          //pushes = await Pushes().loadPushesFromFile('pushes.dat');
          goGo(1);
        } else {
          if (verbose >=1) print('GUIDS file not exists. Got to Login Screen');
          goGo(0);//return 0;
        }
      } else {
        if (verbose >=1) print('Key File has wrong key. Trying to get new one from FireBase...');
        String _token = await FirebaseHelper().getAppToken();
        devKey = _token;
        if (verbose >=1) print(_token);
        if (_token != null) file.writeAsStringSync(_token, mode: FileMode.write, encoding: utf8);
        if (verbose >=1) print('New Key File created and saved');
        if (verbose >=1) print('Go to Login Screen');
        goGo(0);//return 0;
      }
    } else {
      if (verbose >=1) print('Key file is not exists');
      String _token = await FirebaseHelper().getAppToken();
      devKey = _token;
      if (verbose >=1) print(_token == null ? '' : _token);
      file.writeAsStringSync(_token == null ? '' : _token, mode: FileMode.write, encoding: utf8);
      if (verbose >=1) print('Key File created and saved');
      if (verbose >=1) print('Go to Login Screen');
      goGo(0);
    }
  }
}