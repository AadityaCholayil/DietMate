import 'package:dietmate/auth_screens/login_screen.dart';
import 'package:dietmate/auth_screens/signup_screen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Auth Screen',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            ElevatedButton(
              child:  Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                );
              },
            ),
            ElevatedButton(
              child:  Text(
                'SignUp',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
