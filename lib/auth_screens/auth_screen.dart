import 'package:dietmate/auth_screens/login_screen.dart';
import 'package:dietmate/auth_screens/signup_screen.dart';
import 'package:dietmate/shared/gradient.dart';
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
            Container(
              padding: EdgeInsets.fromLTRB(12, 0,0,5),
              child: GradientText(
                'DietMate',
                size:40.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            GradientButton(
              label: 'Log In',
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                );
              },
            ),
            GradientButton(
              label: 'Sign up',
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
                );
              },
            )


            // ElevatedButton(
            //   child:  Text(
            //     'SignUp',
            //     style: TextStyle(
            //       fontSize: 20,
            //     ),
            //   ),
            //   onPressed: (){
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
