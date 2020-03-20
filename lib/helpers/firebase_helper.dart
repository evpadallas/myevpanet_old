import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myevpanet/main.dart';

class FirebaseHelper{


  //final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  FirebaseHelper(){
    _init();
  }

  void _init(){
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    configure();
  }

  void configure() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        lastMessage = message;
        messageForId = Pushes().parsePushForId(message['notification']['title'].toString());
        Fluttertoast.showToast(
          msg: '${message['notification']['title']} : ${message['notification']['body']}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        /*final snackbar = SnackBar(
          content: Column(
            children: [
              Text(message['notification']['title']),
              Text(message['notification']['body']),
            ],
          ),
          /*action: SnackBarAction(
            label: 'Go',
            onPressed: () => null,
          ),*/
        );
        Scaffold.of(context).showSnackBar(snackbar);*/
        //сохраняем полученную пушку в файл
        Pushes().savePushToFile(message);
        /*showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                //color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );*/
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Fluttertoast.showToast(
          msg: '${message['data']['title']} : ${message['data']['message']}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Pushes().savePushToFile(message);
        // optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Fluttertoast.showToast(
          msg: '${message['data']['title']} : ${message['data']['message']}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Pushes().savePushToFile(message);
        // optional
      },
    );
  }

  Future<String> getAppToken() async{
    return await _fcm.getToken();
  }

  /*Future saveDeviceToken(String json) async{
    //String uid = 'jeff1e7t';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null) {
      print('fcmToken:');
      print(fcmToken);
      var tokens = _db
          .collection('users')
      //.document(uid)
      //.collection('tokens')
          .document(fcmToken);
      //print('tokens.get():');
      //print(await tokens.get());
      await tokens.setData({
        'token': fcmToken,
        //'createdAt': FieldValue.serverTimestamp(), // optional
        'guids': json // optional
      });
    }
  }*/

}