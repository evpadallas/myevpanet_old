import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Paymaster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PaymasterState();
}

class PaymasterState extends State with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff32506a),
            title: Text('Пополнение баланса')
        ),
        body: Image.asset(
            "assets/images/paymaster.png",
          alignment: Alignment.topCenter,
        )
    );
  }
}