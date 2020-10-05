import 'package:flutter/material.dart';

Widget whiteZone(userInfo, context) {
  return
    Expanded(
      child: ListView(
        children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text("ID"),
                subtitle: Text(userInfo["id"]?.toString()),
              ),
              ListTile(
                title: Text("Тарифный план"),
                subtitle: Text(userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
              ),
              ListTile(
                title: Text("Ф.И.О."),
                subtitle: Text(userInfo["name"]),
              ),
              ListTile(
                title: Text('Адрес'),
                subtitle: Text(userInfo["street"] + ", д. " + userInfo["house"] + ", кв. " + userInfo["flat"]),
              ),
              ListTile(
                title: Text('Логин'),
                subtitle: Text(userInfo["login"]),
              ),
              ListTile(
                title: Text('IP адрес абонента'),
                subtitle: Text(userInfo["real_ip"]),
              ),
            ]
        ).toList(),
      )
  );
}