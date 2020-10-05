import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class OrderView extends StatelessWidget {
@override
Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        appBar: AppBar(
          title: Text('Страница пополенения баланса'),
        ),
        url: 'https://evpanet.com/internet/leave-a-statement.html'),
    );
  }

}