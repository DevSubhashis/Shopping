import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ppl/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';
import 'providers/user.dart';
import 'screens/splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
      ],
      child: Phoenix(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    getSaveLanguage();
  }

  getSaveLanguage() async {
    final SharedPreferences prefs = await _prefs;
    String lang = prefs.getString('language');
    if (lang == null) {
      onLocaleChange(Locale(languagesMap["English"]));
    } else {
      onLocaleChange(Locale(languagesMap[lang]));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'PPL',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: PrimaryColor,
        primarySwatch: Colors.grey,
        fontFamily: "CalibriRegular",
      ),
      localizationsDelegates: [
        _newLocaleDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", ""),
        Locale("be", ""),
      ],
      home: SplashScreen(),
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
