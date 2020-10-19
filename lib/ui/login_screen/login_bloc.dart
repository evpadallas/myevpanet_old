import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/model/api/api.dart';
import 'package:myevpanet/ui/main_screen/main_widget.dart';
import 'package:myevpanet/ui/webview_screens/order_widget.dart';

abstract class AuthEvent {}

/// Событие авторизации
class AuthButtonPressedEvent  extends AuthEvent{
  final String phone;
  final String uid;

  AuthButtonPressedEvent(this.phone, this.uid);
}

class NavigateToOrderView extends AuthEvent {}

class LoginState {
  final List<dynamic> guid;
  final String registrationMode;

  LoginState({this.guid, this.registrationMode = 'new'});
}

class LoginBloc extends Bloc<AuthEvent, LoginState> {

  final BuildContext context;

  LoginBloc(LoginState initialState, this.context) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(AuthEvent event)  {
    if (event is AuthButtonPressedEvent) {
      return _performAuth(event);
    } else if (event is NavigateToOrderView) {

    } else {
      throw UnimplementedError();
    }
  }

  Stream<LoginState> _performAuth(AuthButtonPressedEvent event) async* {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    var _phoneNumber = event.phone;
    var _userID = 0;
    if (event.uid != '') {
      _userID = int.parse(event.uid);
    }

    if (_phoneNumber.length == 11 && _userID > 0) {
      //номер телефона достаточной длины и ИД тоже корректный можно идти дальше
      var phone = int.parse(_phoneNumber);
      var id = _userID;
      if (verbose >= 1) print('Entered phone number is: $phone');
      if (verbose >= 1) print('Entered ID is: $id');

      //requesting auth from server
      Map<String, String> result =
          await RestAPI().authorizeUserPOST('+' + phone.toString(), id, devKey);

      //обработка ответа сервера
      bool _checks = true;
      if (result['answer'] == 'isFull') {
        var _body = json.decode(result['body']);
        if (verbose >= 1) print(_body);
        if (!_body['error']) {
          //ошибок нет. в ответе лежат гуиды
          if (registrationMode == 'new') {
            guids = _body['message']['guids'];
          } else {
            //здесь надо к списку гуидов добавить еще гуиды без повторений
            for (var addGuid in _body['message']['guids']) {
              if (!guids.contains(addGuid)) guids.add(addGuid);
            }
            registrationMode = 'new';
          }
        } else {
          //в ответе есть ошибка и ее значение выводим
          _checks = false;
          if (verbose >= 1) print('Got Error: ${_body['message']}');
          Fluttertoast.showToast(
              msg: "Абонент(ов) с такими данными не найдено",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        //ответ был не получен из-за ошибки сети
        _checks = false;
        if (verbose >= 1) print('network error :(');
      }
      if (_checks) {
        if (verbose >= 1) print('Got good GUID(s)');
        //fbHelper.saveDeviceToken(result);
        //сохранение списка гуидов в файл
        if (verbose >= 1) print(guids);
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        _guidsfile.writeAsString(jsonEncode(guids),
            mode: FileMode.write, encoding: utf8);
        currentGuidIndex = 0;
        //запрашиваем сервер данные всех пользователей и сохраняем (обновляем) файлы
        for (var guid in guids) {
          var usersRequest = await RestAPI().userDataGet(guid, devKey);
          if (verbose >= 1) print('$guid: $usersRequest');
          currentGuidIndex++;
          yield LoginState(guid: guids, registrationMode: registrationMode);
        }
        currentGuidIndex = 0;

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MainScreenWidget()));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Введены некорректные данные",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      yield LoginState();
    }
  }

  Stream<LoginState> _performNavigation(NavigateToOrderView event) {
    // Тут колбасим открытие новой страницы с возможностью оставить заявку на подключение (Используем новый API).
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OrderView()));

    return Stream.value(LoginState());
  }

}