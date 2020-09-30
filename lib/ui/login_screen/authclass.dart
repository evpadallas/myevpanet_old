import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myevpanet/domain/api/api.dart';
import 'package:myevpanet/main.dart';

class Auth {
  bool apiReg(String phone, int id) {
    var result = RestAPI().authorizeUserPOST('+' + phone, id, devKey);
    print(result);
    bool _checks = true;
    if (result.toString().contains('00000000-0000-0000-C000-000000000046')) {
      print('Auth failed. No such users.');
      Fluttertoast.showToast(
          msg: "Такой пользователь не найден",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      _checks = false;
    }
    print(result.toString().length);
    if (result.toString().length < 38) {
      print('Got bad answer. Do nothing');
      _checks = false;
    }
    if (result.toString().contains('Exception')) {
      print('Got Exception Error');
      _checks = false;
    }
    return _checks;
  }
}
