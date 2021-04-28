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
              padding: EdgeInsets.fromLTRB(12, 0,0,70),
              // child: GradientText(
              //   'DietMate',
              //   size:50.0,
              //   fontWeight: FontWeight.bold,
              // ),
              child: Text(
                'DietMate',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            GradientButton(
              label: Text('Log In',
                style: TextStyle(
                  fontSize:25.0,
                  fontWeight: FontWeight.w300,
              ),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                );
              },
              extraPaddingWidth: 108.0,
            ),
            SizedBox(height:15),
            GradientButton(
              label: Text('Sign up',
                style: TextStyle(
                  fontSize:25.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
                );
              },
              extraPaddingWidth: 100.0,
            ),


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
