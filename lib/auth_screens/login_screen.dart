import 'package:dietmate/services/auth.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String error = '';
  bool loading = false;
  bool errorOccured= true;

  // text field state
  String email = '';
  String password = '';

  Widget _buildEmail(){
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 18,15, 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
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
        // var email = "tony@starkindustries.com"
        // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
        return null;
      },
      onSaved: (String value) {
        email= value;
      },
    );
  }

  Widget _buildPassword(){
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 18,15, 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Password',
          labelStyle: TextStyle(fontSize: 25),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      obscureText: true,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password cannot be empty';
        }
        return null;
      },
      onSaved: (String value) {
        password= value;
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Auth1_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: 25),
              _buildEmail(),
              SizedBox(height: 10),
              _buildPassword(),
              SizedBox(height: 10),
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
                    errorOccured=false;
                    _formKey.currentState.save();
                  });
                  dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                  if(result == null) {
                    setState(() {
                      loading = false;
                      error = 'Could not log in with those credentials';
                      errorOccured=true;
                    });
                  }
                },
              ),
              errorOccured? Text(
                error,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.w300,
                    color: Colors.red,
                ),

              ): SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
