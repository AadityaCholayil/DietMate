import 'package:dietmate/model/user.dart';
import 'package:dietmate/pages/debug_page.dart';
import 'package:dietmate/services/auth.dart';
import 'package:dietmate/themes/custom_theme.dart';
import 'package:dietmate/themes/dark_theme.dart';
import 'package:dietmate/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final AuthService _auth = AuthService();
  bool _darkTheme=true;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  SwitchListTile _buildTheme(ThemeNotifier themeNotifier) {
    return SwitchListTile(
      title: Text('Dark Theme?'),
      value: _darkTheme,
      onChanged: (bool newValue) async {
        setState(() {
          _darkTheme=newValue;
        });
        onThemeChanged(newValue, themeNotifier);
      },
    );
  }

  ElevatedButton _buildDebugPage(BuildContext context) {
    return ElevatedButton(
      child: Text('Debug Page'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => DebugPage()),
        );
      },
    );
  }

  Widget _buildSignOut(){
    return TextButton(
      child: Text(
        'Sign Out',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      onPressed: () async {
        await _auth.signOut();
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);

    final userData = Provider.of<UserData>(context);
    return Scaffold(
      body: Container(
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
            _buildTheme(themeNotifier),
            _buildDebugPage(context),
            _buildSignOut(),
          ],
        ),
      ),
    );
  }
}

