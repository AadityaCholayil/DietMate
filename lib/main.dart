import 'package:dietmate/auth_screens/wrapper.dart';
import 'package:dietmate/services/auth.dart';
import 'package:dietmate/shared/splash_screen.dart';
import 'package:dietmate/themes/custom_theme.dart';
import 'package:dietmate/themes/dark_theme.dart';
import 'package:dietmate/themes/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          builder: (context, widget) {
            return widget;
          },
        ),
      );
    });
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (_error) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        home: Scaffold(body: SplashScreen()),
      );
    }
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        home: Scaffold(body: SplashScreen()),
      );
    }
    User user = FirebaseAuth.instance.currentUser ?? null;
    return StreamProvider<User>.value(
        initialData: user, value: AuthService().user, child: Wrapper());
  }
}
