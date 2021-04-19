import 'package:dietmate/services/auth.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String error = '';
  bool loading = false;

  // text field state
  String email = 'aadi1@xyz.com';
  String password = 'aadi123';

  Widget _buildName(){
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   width: 2,
        //   color: Theme.of(context).disabledColor
        // ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            suffixIcon: Icon(Icons.search, size: 28),
            labelText: 'Email Id',
            labelStyle: TextStyle(fontSize: 25),
            floatingLabelBehavior: FloatingLabelBehavior.never
        ),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Invalid Email Id';
          }
          return null;
        },
        onSaved: (String value) {
          email= value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Page',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              loading?LoadingSmall():ElevatedButton(
                child:  Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  setState(() {
                    loading = true;
                    _formKey.currentState.save();
                  });
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
      ),
    );
  }
}
