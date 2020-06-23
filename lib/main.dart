import 'package:flutter/material.dart';
import 'package:myevpanet/helpers/firebase_helper.dart';
import 'package:myevpanet/splash_screen/splash_widget.dart';

int verbose = 1;
List guids = [];
List pushes = [];
List<String> sharedPushes = [];
String devKey;
int currentGuidIndex = 0;
Map userInfo;
//bool useNewApiVersion = true;
var users = Map();
FirebaseHelper fbHelper;
int messageForId = 0;
Map<String, dynamic> lastMessage;
bool lastMessageIsSeen = false;
//GlobalKey refreshKey;
String registrationMode = 'new';

void main() {
  runApp(App());
}

//
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //моя проба с пушем
    fbHelper = FirebaseHelper();
    //fbHelper.configure(context);
    return MaterialApp(
      theme: ThemeData (
          primaryColorDark: Color(0xFF1976d2),
          primaryColor: Color(0xFF2196f3),
          accentColor: Color(0xFFff5722),
          primaryColorLight: Color(0xFFbbdefb),
        ),
      debugShowCheckedModeBanner: false,
        home: SplashWidget(),
    );
  }
}
