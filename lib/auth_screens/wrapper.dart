import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/auth_screens/auth_screen.dart';
import 'package:dietmate/home_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:dietmate/themes/dark_theme.dart';
import 'package:dietmate/themes/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user!=null) {
      return StreamProvider<UserData>.value(
        initialData: null,
        value: DatabaseService(uid: user.uid).userData,
        child: Builder(
            builder: (BuildContext context){
              final userData = Provider.of<UserData>(context);
              if (userData!=null) {
                if (userData.name=='firebase_default') {
                  return MaterialApp(
                    theme: userData.isDarkMode?darkTheme:lightTheme,
                    home: AdditionalDetailsScreen(),
                  );
                } else {
                  return MaterialApp(
                    theme: userData.isDarkMode?darkTheme:lightTheme,
                    home: HomeScreen(),
                  );
                }
              } else {
                return MaterialApp(
                    home: Loading()
                );
              }
            }
        ),
      );
    } else {
      return MaterialApp(
          home: AuthScreen()
      );
    }

  }
}
