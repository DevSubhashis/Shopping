import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppl/screens/profile/sign_in.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:country_code_picker/country_code_picker.dart';

ProgressDialog pr;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  final lnameFocus = FocusNode();
  final emailFocus = FocusNode();
  final mobileFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final referralCodeFocus = FocusNode();
  String _fname;
  String _lname;
  String _email;
  String _countryCode = '+880';
  String _mobile;
  String _password;
  String _conpassword;
  String _refCode;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  void doValidate() {
    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();
      doSignUp();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void doSignUp() {
    pr.show();
    Map body = {
      "first_name": _fname,
      "last_name": _lname,
      "email": _email,
      "country_code": _countryCode,
      "mobile": _mobile,
      "password": _password,
      "referral_code": _refCode != null ? _refCode : "",
    };
    print(body);
    WebService api = WebService();
    final response = api.callPostAPI(SIGN_UP_URL, body, '');
    response.then((value) {
      //print(value.body);
      if (pr.isShowing()) {
        pr.hide();
      }
      var decodedData = jsonDecode(value.body);
      final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      if (statusCode == 400) {
        // final String userId =
        //     decodedData['result']['profileDetails']['encryptedUserId'];
        this._showDialogError(message);
      } else {
        this._showDialogSuccess(message);
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

  String validateFirstName(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      if (value.length < 3)
        return AppTranslations.of(context).text('fnameError');
      else
        return null;
    }
  }

  String validateLastName(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      if (value.length < 3)
        return AppTranslations.of(context).text('lnameError');
      else
        return null;
    }
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

  String validatePh(String value) {
    if (value.length == 0)
      return AppTranslations.of(context).text('required');
    else
      return null;
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

  String validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return AppTranslations.of(context).text('required');
    } else {
      var password = passKey.currentState.value;
      if (value != password) {
        return AppTranslations.of(context).text('confirmPasswordError');
      } else {
        return null;
      }
    }
  }

  Widget signUpFormUI() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('first_name'),
            ),
            validator: validateFirstName,
            onSaved: (val) => _fname = val,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(lnameFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('last_name'),
            ),
            validator: validateLastName,
            onSaved: (val) => _lname = val,
            focusNode: lnameFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(emailFocus);
            },
          ),
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
              FocusScope.of(context).requestFocus(mobileFocus);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: 60,
                margin: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CountryCodePicker(
                    onChanged: (e) => _countryCode = e.dialCode,
                    initialSelection: 'BD',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppTranslations.of(context).text('mobile'),
                  ),
                  validator: validatePh,
                  onSaved: (val) => _mobile = val,
                  focusNode: mobileFocus,
                  onFieldSubmitted: (term) {
                    FocusScope.of(context).requestFocus(passwordFocus);
                  },
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            obscureText: true,
            key: passKey,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('password'),
            ),
            validator: validatePassword,
            onSaved: (val) => _password = val,
            focusNode: passwordFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(confirmPasswordFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            obscureText: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('confirm_password'),
            ),
            validator: validateConfirmPassword,
            onSaved: (val) => _conpassword = val,
            focusNode: confirmPasswordFocus,
            onFieldSubmitted: (term) {
              FocusScope.of(context).requestFocus(referralCodeFocus);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppTranslations.of(context).text('referral_code'),
            ),
            onSaved: (val) => _refCode = val,
            focusNode: referralCodeFocus,
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
              AppTranslations.of(context).text('signup'),
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
              AppTranslations.of(context).text('signup'),
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
        padding: EdgeInsets.all(10),
        child: Form(
          key: _signUpFormKey,
          autovalidate: _autoValidate,
          child: signUpFormUI(),
        ),
      ),
    );
  }
}
