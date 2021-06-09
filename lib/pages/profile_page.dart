import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/pages/debug_page.dart';
import 'package:dietmate/services/auth.dart';
import 'package:dietmate/shared/gradient.dart';
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
  bool debugMode=false;

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
          fontSize: 21,
          fontWeight: FontWeight.w400
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
          fontSize: 22,
        ),
      ),
      onPressed: () async {
        await _auth.signOut();
      },
    );
  }

  Row _buildRow(String left, String right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            left,
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w400
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            right,
            style: TextStyle(
                fontSize: 22,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
      ],
    );
  }

  Container buildHeader(BuildContext context, String header) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      color:Theme.of(context).highlightColor.withOpacity(0.2),
      child: Text(
        header,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.vertical(bottom: Radius.elliptical(90, 40)),
                ),
                elevation: 0,
                child: Container(
                  height: width*0.45,
                  width: width,
                  decoration: BoxDecoration(
                      gradient: customGradient
                  ),
                  // color: Theme.of(context).accentColor,
                  child: SizedBox(),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(25,25,0,30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Profile',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff176607),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData.userProfileUrl),
                        radius: 70,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment.center,
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
                              MaterialPageRoute(builder: (BuildContext context) => AdditionalDetailsScreen(userData: userData,)),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildHeader(context, 'DETAILS'),
                          Container(
                            padding: EdgeInsets.only(left: 20,top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRow('Age', '${userData.age}'),
                                SizedBox(height:10),
                                _buildRow('Height', '${userData.height} cm'),
                                SizedBox(height:10),
                                _buildRow('Weight', '${userData.weight} kg'),
                                SizedBox(height:10),
                                _buildRow('Gender', '${userData.isMale?'Male':'Female'}'),
                                SizedBox(height:10),
                                _buildRow('Joining Date', '${userData.joinDate}'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          buildHeader(context, 'PREFERENCES'),
                        ],
                      ),
                    ),
                    _buildTheme(themeNotifier),
                    // SizedBox(height: 4),
                    buildHeader(context, 'ACCOUNT ACTIONS'),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _buildSignOut(),
                    ),
                    debugMode?Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _buildDebugPage(context),
                    ):SizedBox.shrink(),
                    SizedBox(height: 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

