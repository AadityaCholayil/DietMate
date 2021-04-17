import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/auth_screens/login_screen.dart';
import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/auth_screens/signup_screen.dart';
import 'package:dietmate/auth_screens/auth_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:dietmate/themes/custom_theme.dart';
import 'package:dietmate/themes/dark_theme.dart';
import 'package:dietmate/themes/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeerajTemp extends StatefulWidget {
  @override
  _NeerajTempState createState() => _NeerajTempState();
}

class _NeerajTempState extends State<NeerajTemp> {

  bool _darkTheme=true;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    if(userData==null){
      return Loading();
    }

    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Auth Screens(Temporary)\n(Neeraj)\nGitHub branch',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text('Start Screen(1)'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
                ),
              ),
              ElevatedButton(
                child: Text('Sign up Screen(2a)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Login Screen(2)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Additional Details(2b)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => AdditionalDetailsScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Plan Screen(2c)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => PlanScreen()),
                  );
                },
              ),
              SwitchListTile(
                title: Text('Dark Theme?'),
                value: _darkTheme,
                onChanged: (bool newValue) async {
                  setState(() {
                    _darkTheme=newValue;
                  });
                  onThemeChanged(newValue, themeNotifier);
                },
              ),
            ],
          )
      ),
    );
  }
}
