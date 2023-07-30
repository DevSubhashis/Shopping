import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/providers/user.dart';
import 'package:ppl/screens/home/addresses.dart';
import 'package:ppl/screens/profile/change_password.dart';
import 'package:ppl/screens/profile/edit_profile.dart';
import 'package:ppl/screens/profile/select_language.dart';
import 'package:ppl/services/services.dart';
import 'package:ppl/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool isLogedin = false;

  void doLogout() {
    pr.show();
    var user = Provider.of<UserModel>(context, listen: false);
    WebService api = WebService();
    final response =
        api.callPostAPI(SIGN_OUT, {}, user.userData['auth']['_token']);
    response.then((value) {
      //print(value.body);
      if (pr.isShowing()) {
        pr.hide();
      }
      var decodedData = jsonDecode(value.body);
      //final int statusCode = decodedData['serverResponse']['code'];
      final String message = decodedData['serverResponse']['message'];
      final bool isSuccess = decodedData['serverResponse']['isSuccess'];
      //final String result = json.encode(decodedData['result']);
      if (isSuccess) {
        user.doRemoveUser();
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

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserModel>(context, listen: false);
    if (user.userData.isNotEmpty) {
      setState(() {
        isLogedin = true;
      });
    } else {
      setState(() {
        isLogedin = false;
      });
    }
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
              AppTranslations.of(context).text('account_settings'),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'CalibriBold',
                fontSize: 16.0,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              splashColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/images/icon_chat_bubble.svg',
                color: Colors.white,
                fit: BoxFit.contain,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Consumer<UserModel>(builder: (context, user, child) {
        // String token =
        //     user.userData.isNotEmpty ? user.userData['auth']['_token'] : 'none';
        return ListView(
          //padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
          children: <Widget>[
            Container(
              color: Colors.black12,
              padding: EdgeInsets.all(5.0),
              child: Text("My Account"),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                              userData: user.userData['auth']),
                        ),
                      );
                    },
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('my_Profile'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressesScreen()),
                      );
                    },
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('my_addresses'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('bank_accounts'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black12,
              padding: EdgeInsets.all(5.0),
              child: Text("Settings"),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('chat_settings'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context)
                                .text('notification_settings'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context)
                                .text('privacy_settings'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('blocked_users'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectLanguageScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('language'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  isLogedin
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePassScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 40.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppTranslations.of(context)
                                      .text('change_password'),
                                  style: TextStyle(
                                    fontFamily: 'CalibriRegular',
                                    fontSize: 14.0,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              color: Colors.black12,
              padding: EdgeInsets.all(5.0),
              child: Text("Support"),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('help_center'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('tips_tricks'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('community_rules'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('ppl_policies'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('happy_ppl'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context).text('about_us'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppTranslations.of(context)
                                .text('account_deletion'),
                            style: TextStyle(
                              fontFamily: 'CalibriRegular',
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            if (isLogedin)
              Container(
                width: double.infinity,
                height: 45.0,
                margin: EdgeInsets.all(15.0),
                child: FlatButton(
                  onPressed: () {
                    this.doLogout();
                  },
                  color: Colors.red,
                  splashColor: Colors.white,
                  child: Text(
                    AppTranslations.of(context).text('logout'),
                    style: TextStyle(
                      fontFamily: 'CalibriRegular',
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
