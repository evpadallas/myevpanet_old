import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/ui/login_screen/login_bloc.dart';
import 'package:myevpanet/ui/webview_screens/order_widget.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State with SingleTickerProviderStateMixin {
  var phone = new MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  var uid = new MaskTextInputFormatter(
      mask: '#####', filter: {"#": RegExp(r'[0-9]')});

  LoginBloc _bloc;
  final String assetName = 'assets/images/evpanet_auth_logo.svg';

  @override
  void initState() {
    super.initState();
    currentGuidIndex = 0;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc = LoginBloc(LoginState(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocBuilder<LoginBloc, LoginState>(
          cubit: _bloc,
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff11273c), Color(0xff3c5d7c)])),
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height),
                        child: Container(
                          padding: EdgeInsets.only(
                            top:
                                ResponsiveFlutter.of(context).verticalScale(20),
                          ),
                          height:
                              ResponsiveFlutter.of(context).verticalScale(600),
                          width: ResponsiveFlutter.of(context).scale(300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              _buildLogoTop(),
                              _buildPhoneField(),
                              _buildUIDField(),
                              _buildSubmitButton(state.registrationMode),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: LinearProgressIndicator(
                                  value: currentGuidIndex /
                                      (state.guid.isNotEmpty
                                          ? state.guid.length
                                          : 1),
                                  backgroundColor: Color(0xff3c5d7c),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: ResponsiveFlutter.of(context)
                                      .moderateScale(8),
                                  bottom: ResponsiveFlutter.of(context)
                                      .moderateScale(8),
                                ),
                                child: Row(children: <Widget>[
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 15.0),
                                        child: Divider(
                                          color: Color(0xffd3edff),
                                          height: 50,
                                        )),
                                  ),
                                  Text(
                                    "или",
                                    style: TextStyle(
                                        color: Color(0xffd3edff),
                                        fontSize: ResponsiveFlutter.of(context)
                                            .fontSize(1.5)),
                                  ),
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 10.0),
                                        child: Divider(
                                          color: Color(0xffd3edff),
                                          height: 50,
                                        )),
                                  ),
                                ]),
                              ),
                              _buildConnectRequestButton(),
                            ],
                          ),
                          alignment: Alignment(0.0, 0.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildLogoTop() {
    return Center(
        child: Container(
            padding: EdgeInsets.only(
              top: ResponsiveFlutter.of(context).moderateScale(20),
              bottom: ResponsiveFlutter.of(context).moderateScale(20),
              right: ResponsiveFlutter.of(context).moderateScale(8),
              left: ResponsiveFlutter.of(context).moderateScale(8),
            ),
            child: SvgPicture.asset(
              assetName,
              color: Color(0xffd3edff),
            )));
  }

  Widget _buildPhoneField() {
    return Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: TextField(
          //controller: textEditingController,
          inputFormatters: [phone],
          keyboardType: TextInputType.phone,
          style: TextStyle(color: Color(0xffd3edff), fontSize: 18.0),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
              labelText: 'Номер телефона',
              labelStyle: TextStyle(
                color: Color(0xffd3edff),
                letterSpacing: 1,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffd3edff))),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffd3edff)))),
        ));
  }

  Widget _buildUIDField() {
    return Padding(
        padding: EdgeInsets.only(
          top: ResponsiveFlutter.of(context).moderateScale(8),
          bottom: ResponsiveFlutter.of(context).moderateScale(8),
        ),
        child: TextField(
          inputFormatters: [uid],
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Color(0xffd3edff),
          ),
          decoration: InputDecoration(
              labelText: 'Ваш ИД (ID)',
              labelStyle: TextStyle(
                color: Color(0xffd3edff),
                letterSpacing: 1,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffd3edff))),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffd3edff)))),
        ));
  }

  Widget _buildSubmitButton(String registraionMode) {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveFlutter.of(context).moderateScale(20),
        bottom: ResponsiveFlutter.of(context).moderateScale(8),
        right: ResponsiveFlutter.of(context).moderateScale(8),
        left: ResponsiveFlutter.of(context).moderateScale(8),
      ),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(side: BorderSide(color: Color(0xff95abbf))),
        elevation: 0.0,
        onPressed: devKey != null
            ? () {
                _bloc.add(AuthButtonPressedEvent(
                    phone.getUnmaskedText(), uid.getUnmaskedText()));
              }
            : null,
        color: Color(0x858eaac2),
        child: Padding(
          padding:
              EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                getAuthButtonPressed(registraionMode),
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  String getAuthButtonPressed(String registraionMode) {
    if (devKey == null) return 'Нет доступа к интернету ';
    switch (registrationMode) {
      case 'new':
        return 'Войти в кабинет ';
        break;
      case 'add':
        return 'Добавить ';
        break;
      default:
        return 'Войти в кабинет ';
    }
  }

  Widget _buildConnectRequestButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: ResponsiveFlutter.of(context).moderateScale(2),
        bottom: ResponsiveFlutter.of(context).moderateScale(8),
        right: ResponsiveFlutter.of(context).moderateScale(8),
        left: ResponsiveFlutter.of(context).moderateScale(8),
      ),
      child: RaisedButton(
        elevation: 0.0,
        onPressed: devKey != null
            ? () {
                _bloc.add(NavigateToOrderView());
              }
            : null,
        color: Color(0x408eaac2),
        child: Padding(
          padding:
              EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person_add,
                color: Colors.white,
              ),
              Text(
                devKey != null ? ' Подключиться' : 'Нет доступа к интернету',
                style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
