import 'package:dietmate/model/user.dart';
import 'package:dietmate/pages/debug_page.dart';
import 'package:dietmate/services/auth.dart';
import 'package:dietmate/themes/custom_theme.dart';
import 'package:dietmate/themes/dark_theme.dart';
import 'package:dietmate/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final AuthService _auth = AuthService();
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

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    final userData = Provider.of<UserData>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/setting_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings Page',
              style: TextStyle(
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Name: ${userData.name}, ${userData.joinDate}',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
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
            ElevatedButton(
              child: Text('Debug Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => DebugPage()),
                );
              },
            ),
            TextButton(
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

