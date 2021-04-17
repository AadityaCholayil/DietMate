import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final AuthService _auth = AuthService();
  String error = '';
  bool loading = false;

  String email = 'aadi1@xyz.com';
  String password = 'aadi123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SignUp Page',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            ElevatedButton(
              child:  Text(
                'SignUp',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                setState(() => loading = true);
                UserData userData = UserData(
                  name: 'firebase_default',
                  age: 1,
                  isMale: true,
                  height: 1,
                  weight: 1,
                  activityLevel: 1,
                );
                dynamic result = await _auth
                    .registerWithEmailAndPassword(email, password, userData);
                if(result == null) {
                  setState(() {
                    loading = false;
                    error = 'Please supply a valid email';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
