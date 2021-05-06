import 'package:dietmate/auth_screens/login_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/auth.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String error = '';
  bool loading = false;
  bool errorOccured=false;

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

  Widget logInButton(){
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.only(bottom: 15),
          primary: Color(0xFF2ACD07)
      ),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 20,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: (){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()
            )
        );
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
                  'SignUp',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height:25),
              _buildEmail(),
              SizedBox(height:10),
              _buildPassword(),
              SizedBox(height:10),
              Container(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    logInButton(),
                  ],
                ),
              ),
              loading?LoadingSmall():ElevatedButton(
                child:  Text(
                  'SignUp',
                  style: TextStyle(
                    fontSize: 25,
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
                  } );
                  UserData userData = UserData(
                    name: 'firebase_default',
                    age: 1,
                    isMale: true,
                    height: 1,
                    weight: 1,
                    activityLevel: 1,
                    calorieGoal: 1,
                    joinDate: '',
                  );
                  dynamic result = await _auth
                      .registerWithEmailAndPassword(email, password, userData);
                  if(result == null) {
                    setState(() {
                      loading = false;
                      error = 'Please supply a valid email';
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
