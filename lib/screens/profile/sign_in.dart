import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/screens/profile/resend_verify_email.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:provider/provider.dart';

import 'forgot_pass.dart';

ProgressDialog pr;

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  String _email;
  String _password;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  void doValidate() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      doLogin();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void doLogin() {
    pr.show();
    var user = Provider.of<UserModel>(context, listen: false);
    Map body = {"email": _email, "password": _password};
    // print(body);
    WebService api = WebService();
    final response = api.callPostAPI(SIGN_IN_URL, body, '');
    response.then((value) {
      //print(value.body);
      if (pr.isShowing()) {
        pr.hide();
      }
      var decodedData = jsonDecode(value.body);
      //final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      final bool isSuccess = decodedData['serverResponse']['isSuccess'];
      final String result = json.encode(decodedData['result']);
      if (isSuccess) {
        print(decodedData);
        user.doAddUser(result);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        this._showDialogError(message);
      }
    }).catchError((onError) {
      if (pr.isShowing()) {
        pr.hide();
      }
      this._showDialogError(onError);
    });
  }

  void _showDialogError(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppTranslations.of(context).text('error')),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(AppTranslations.of(context).text('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      Pattern pattern = emailPattern;
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return AppTranslations.of(context).text('validMailError');
      else
        return null;
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      if (value.length <= 7)
        return AppTranslations.of(context).text('passwordError');
      else
        return null;
    }
  }

  Widget logInFormUI() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Image.asset(
          'assets/images/icon.png',
          width: MediaQuery.of(context).size.width / 2,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 80,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('email'),
            ),
            validator: validateEmail,
            onSaved: (val) => _email = val,
            focusNode: emailFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(passFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('password'),
            ),
            validator: validatePassword,
            onSaved: (val) => _password = val,
            focusNode: passFocus,
            onFieldSubmitted: (term) {
              this.doValidate();
            },
          ),
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: RaisedButton(
            textColor: Colors.white,
            splashColor: Colors.white,
            color: PrimaryColor,
            child: Text(
              AppTranslations.of(context).text('login'),
              style: TextStyle(
                fontFamily: 'CalibriRegular',
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              this.doValidate();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              child: Text(
                  AppTranslations.of(context).text('forgot_password') + " ?"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassScreen()),
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              child: Text(AppTranslations.of(context)
                  .text('resend_verification_email')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResendVerifyPassScreen()),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 55.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.5,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
              ),
            ),
          ),
          centerTitle: false,
          title: Container(
            child: Text(
              AppTranslations.of(context).text('login'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: new Form(
            key: _loginFormKey,
            autovalidate: _autoValidate,
            child: logInFormUI(),
          ),
        ),
      ),
    );
  }
}
