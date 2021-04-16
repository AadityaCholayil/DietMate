import 'package:dietmate/services/auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _auth = AuthService();
  //final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
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
              onPressed: () async {
                setState(() => loading = true);
                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                if(result == null) {
                  setState(() {
                    loading = false;
                    error = 'Could not sign in with those credentials';
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
