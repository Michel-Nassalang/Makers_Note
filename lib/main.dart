import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maker_note/listcomposant.dart';
import 'package:maker_note/theme.dart';
import 'package:maker_note/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? false;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Maker\'s Note',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: AnimatedSplashScreen(
        backgroundColor: Theme.of(context).backgroundColor,
        splash: Image.asset('images/makers.png'),
        splashIconSize: 350,
        nextScreen: Listcomposant(title: 'Maker\'s Note'),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
