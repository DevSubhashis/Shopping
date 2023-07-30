import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ppl/screens/tabs.dart';
import 'package:ppl/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TabsScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PrimaryColor,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Image.asset(
              'assets/images/icon.png',
              width: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
