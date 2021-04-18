import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/auth_screens/auth_screen.dart';
import 'package:dietmate/home_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:dietmate/themes/custom_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    if (user!=null) {
      return StreamProvider<UserData>.value(
        initialData: null,
        value: DatabaseService(uid: user.uid).userData,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.getTheme(),
          home: HomeScreen(),
        ),
        builder: (context, widget){
          final userData = Provider.of<UserData>(context);
          if (userData!=null) {
            if (userData.name=='firebase_default') {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeNotifier.getTheme(),
                home: AdditionalDetailsScreen(),
              );
            } else {
              return widget;
            }
          } else {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeNotifier.getTheme(),
                home: Loading()
            );
          }
        },
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.getTheme(),
        home: AuthScreen()
      );
    }
  }
}
