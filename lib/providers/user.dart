import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier {
  Map userData = Map();

  UserModel() {
    initUserModel();
  }

  void initUserModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userData = (await prefs.get('userData') ?? "");
    userData = _userData.isNotEmpty ? json.decode(_userData) as Map : {};
    // print(userData);
    notifyListeners();
  }

  void doAddUser(response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userData = json.decode(response) as Map;
    await prefs.setString('userData', json.encode(userData));
    // print(userData);
    notifyListeners();
  }

  void doUpdateUser(response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map newUserData = await json.decode(response) as Map;
    userData['data'] = await newUserData['data'];
    await prefs.setString('userData', json.encode(userData));
    // print(userData);
    notifyListeners();
  }

  void doRemoveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userData = {};
    await prefs.remove('userData');
    // print(userData);
    notifyListeners();
  }
}
