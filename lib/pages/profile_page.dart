import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/pages/debug_page.dart';
import 'package:dietmate/services/auth.dart';
import 'package:dietmate/themes/custom_theme.dart';
import 'package:dietmate/themes/dark_theme.dart';
import 'package:dietmate/themes/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      title: Text('Dark Theme',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800
        ),
      ),
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
      child: Text('Debug Page',
        style: TextStyle(
          fontSize: 20
        ),
      ),
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
          fontSize: 25,
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
    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(40,30,0,16),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff176607),
                  ),
                ),
              ),
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54
                ),
                  width: MediaQuery.of(context).size.width,
                  height:180.0,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                ),
                ),
                //alignment: Alignment.center,
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left:125),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${userData.name}',
                      style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${user.email}',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Container(
                child: Center(
                  child: ElevatedButton(
                    child: Text('Edit Profile  >',
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    //style: ButtonStyle(shape:MaterialStateProperty.all()),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => AdditionalDetailsScreen()),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      color:Theme.of(context).highlightColor.withOpacity(0.2),
                      child: Text(
                        'DETAILS',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                    padding: EdgeInsets.only(left: 20,top: 10),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(width: 150),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData.age.toString()}',
                                style: TextStyle(
                                  fontSize: 25
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        children: [
                          Text(
                            'Height',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(width: 121),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData.height.toString()} cm',
                                style: TextStyle(
                                    fontSize: 25
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        children: [
                          Text(
                            'Gender',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(width: 115),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData.isMale?'Male':'Female'}',
                                style: TextStyle(
                                    fontSize: 25
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        children: [
                          Text(
                            'Activity Level',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(width: 50),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData.activityLevel}',
                                style: TextStyle(
                                    fontSize: 25
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10),
                      Row(
                        children: [
                          Text(
                            'Joining Date',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(width: 58),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData.joinDate}',
                                style: TextStyle(
                                    fontSize: 25
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      color:Theme.of(context).highlightColor.withOpacity(0.2),
                      child: Text(
                        'THEME',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildTheme(themeNotifier),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                color:Theme.of(context).highlightColor.withOpacity(0.2),
                child: Text(
                  'ACCOUNT ACTIONS',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _buildSignOut(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: _buildDebugPage(context),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}

