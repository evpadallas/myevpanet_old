import 'package:flutter/material.dart';
import 'package:myevpanet/ui/login_screen/login_widget.dart';
import 'package:myevpanet/main.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          //shrinkWrap: true,
          padding: EdgeInsets.zero,
          children:
              //DrawerHeader(child: Text('Список ваших учетных записей:')),
              idList(context)),
    );
  }

  List<Widget> idList(context) {
    List<Widget> list = [];
    list.add(
      UserAccountsDrawerHeader(
        accountName: Text('${userInfo['name']}'),
        accountEmail: Text('${userInfo['login']}'),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
              0.2,
              1.0,
            ],
                colors: [
              Color.fromRGBO(68, 98, 124, 1),
              Color.fromRGBO(10, 33, 51, 1)
            ])),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
              ? Colors.white
              : Colors.white,
          child: Text(
            '${userInfo['name'].substring(0, 1)}',
            style: TextStyle(
                fontSize: 40.0, color: Color.fromRGBO(72, 95, 113, 1.0)),
          ),
        ),
      ),
    );
    list.add(Column(
      children: <Widget>[
        FlatButton(
            onPressed: () {
              registrationMode = 'new';
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginWidget()));
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Повторная регистрация', textAlign: TextAlign.left),
            )),
        Divider(),
        FlatButton(
            onPressed: () {
              registrationMode = 'add';
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginWidget()));
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Добавить ID', textAlign: TextAlign.left),
            )),
        Divider(),
      ],
    ));
    return list;
  }
}
