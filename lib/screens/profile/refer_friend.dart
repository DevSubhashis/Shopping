import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppl/utils/constants.dart';
import 'package:ppl/localization/app_translations.dart';

class ReferFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              AppTranslations.of(context).text('refer_friend'),
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
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Text(
                AppTranslations.of(context).text('coin_earn'),
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'CalibriBold',
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                AppTranslations.of(context).text('coin_sub_text'),
                style: TextStyle(
                  fontFamily: 'CalibriRegular',
                  fontSize: 14.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CalibriRegular',
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: MediaQuery.of(context).size.width - 70.0,
                child: SvgPicture.asset(
                  'assets/images/money.svg',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                child: FlatButton(
                  onPressed: () {},
                  color: Colors.blue,
                  child: Text(
                    AppTranslations.of(context).text('coin_bttn_text'),
                    style: TextStyle(
                      fontFamily: 'CalibriRegular',
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
