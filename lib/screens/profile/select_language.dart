import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppl/localization/app_translations.dart';
import 'package:ppl/localization/application.dart';
import 'package:ppl/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguageScreen extends StatefulWidget {
  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    getSaveLanguage();
  }

  getSaveLanguage() async {
    final SharedPreferences prefs = await _prefs;
    String lang = prefs.getString('language');
    if (lang != null) {
      setState(() {
        selectedLanguage = lang;
      });
    }
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  doLanguageChange(lan) {
    setState(() {
      selectedLanguage = lan;
    });
  }

  doSaveLanguage() async {
    final SharedPreferences prefs = await _prefs;
    print(selectedLanguage);
    onLocaleChange(Locale(languagesMap[selectedLanguage]));
    prefs.setString('language', selectedLanguage).then((value) {
      // Navigator.pop(context);
      Phoenix.rebirth(context);
    });
  }

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
              AppTranslations.of(context).text('select_language'),
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
              icon: Icon(Icons.check),
              onPressed: () => doSaveLanguage(),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
        children: <Widget>[
          InkWell(
            onTap: () => doLanguageChange('English'),
            child: Container(
              height: 40.0,
              child: Row(
                children: <Widget>[
                  selectedLanguage == 'English'
                      ? Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Icon(
                            Icons.check,
                            color: PrimaryColor,
                          ),
                        )
                      : SizedBox(
                          width: 49.0,
                        ),
                  Text(
                    'English',
                    style: TextStyle(
                      fontFamily: 'CalibriRegular',
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () => doLanguageChange('Bengali'),
            child: Container(
              height: 40.0,
              child: Row(
                children: <Widget>[
                  selectedLanguage == 'Bengali'
                      ? Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Icon(
                            Icons.check,
                            color: PrimaryColor,
                          ),
                        )
                      : SizedBox(
                          width: 49.0,
                        ),
                  Text(
                    'বাংলা',
                    style: TextStyle(
                      fontFamily: 'CalibriRegular',
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
