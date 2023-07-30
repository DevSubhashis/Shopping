import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:provider/provider.dart';

ProgressDialog pr;

class ChangePassScreen extends StatefulWidget {
  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final GlobalKey<FormState> _changePassFormKey = GlobalKey<FormState>();
  final oldPassFocus = FocusNode();
  final newPassFocus = FocusNode();
  String _oldPass;
  String _newPass;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  void doValidate() {
    if (_changePassFormKey.currentState.validate()) {
      _changePassFormKey.currentState.save();
      doChangePassword();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void doChangePassword() {
    pr.show();
    Map body = {"old_password": _oldPass, "new_password": _newPass};
    // print(body);
    WebService api = WebService();
    var user = Provider.of<UserModel>(context, listen: false);
    final response =
        api.callPostAPI(CHANGE_PASSWORD, body, user.userData['auth']['_token']);
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

  Widget changePasswordUI() {
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
            obscureText: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('old_password'),
            ),
            validator: validatePassword,
            onSaved: (val) => _oldPass = val,
            focusNode: oldPassFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(newPassFocus);
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
              labelText: AppTranslations.of(context).text('new_password'),
            ),
            validator: validatePassword,
            onSaved: (val) => _newPass = val,
            focusNode: newPassFocus,
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
              AppTranslations.of(context).text('change_password'),
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
            key: _changePassFormKey,
            autovalidate: _autoValidate,
            child: changePasswordUI(),
          ),
        ),
      ),
    );
  }
}
