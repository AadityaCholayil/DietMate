import 'package:dietmate/auth_screens/signup_screen.dart';
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
  bool errorOccured= false;
  bool showPassword=false;

  // text field state
  String email = '';
  String password = '';

  Widget _buildEmail(){
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15,15, 15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Email Id',
          labelStyle: TextStyle(fontSize: 22),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
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
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(15, 15,15, 15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2, style: BorderStyle.solid, ),
                borderRadius: BorderRadius.all(Radius.circular(17.0)),
              ),
              fillColor: Theme.of(context).colorScheme.surface,
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: 22),
              floatingLabelBehavior: FloatingLabelBehavior.never
          ),
          obscureText: !showPassword,
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Password cannot be empty';
            }
            return null;
          },
          onSaved: (String value) {
            password= value;
          },
        ),
        Container(
          margin: EdgeInsets.only(right: 15),
          alignment: Alignment.centerRight,
          height: 60,
          child: InkWell(
            onTap: (){
              setState(() {
                showPassword=!showPassword;
              });
            },
            child: Icon(showPassword?Icons.visibility:Icons.visibility_off,)
          ),
        ),
      ],
    );
  }

  Widget signUpButton(){
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(bottom: 15),
        primary: Color(0xFF2ACD07)
      ),
      child: Text(
        'Sign Up',
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
              builder: (BuildContext context) => SignUpScreen()
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
                  'Login',
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(height: 25),
              _buildEmail(),
              SizedBox(height: 10),
              _buildPassword(),
              errorOccured? Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  error,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
              ): SizedBox.shrink(),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    signUpButton(),
                  ],
                ),
              ),
              loading?LoadingSmall():ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
                child:  Text(
                  'Login',
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
            ],
          ),
        ),
      ),
    );
  }
}
