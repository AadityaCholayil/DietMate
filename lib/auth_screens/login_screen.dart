import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Page',
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

              },
            ),
          ],
        ),
      ),
    );
  }
}
