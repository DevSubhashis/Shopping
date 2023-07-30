import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/localization/app_translations.dart';

ProgressDialog pr;

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final GlobalKey<FormState> _forgotPassFormKey = GlobalKey<FormState>();
  final emailFocus = FocusNode();
  String _email;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  void doValidate() {
    if (_forgotPassFormKey.currentState.validate()) {
      _forgotPassFormKey.currentState.save();
      processForgotPassword();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void processForgotPassword() {
    pr.show();
    Map body = {"email": _email};
    // print(body);
    WebService api = WebService();
    var FORGOT_PASS_URL =
        'https://core.projuktipl.com/api/auth/forgot-password';
    final response = api.callPostAPI(FORGOT_PASS_URL, body, '');
    response.then((value) {
      //print(value.body);
      if (pr.isShowing()) {
        pr.hide();
      }
      var decodedData = jsonDecode(value.body);
      //final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      final bool isSuccess = decodedData['serverResponse']['isSuccess'];
      if (isSuccess) {
        this._showDialogSuccess(message);
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

  void _showDialogSuccess(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppTranslations.of(context).text('success')),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(AppTranslations.of(context).text('ok')),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              },
            ),
          ],
        );
      },
    );
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

  Widget forgotPassFormUI() {
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
              AppTranslations.of(context).text('ok'),
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
              AppTranslations.of(context).text('forgot_password'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: new Form(
            key: _forgotPassFormKey,
            autovalidate: _autoValidate,
            child: forgotPassFormUI(),
          ),
        ),
      ),
    );
  }
}
