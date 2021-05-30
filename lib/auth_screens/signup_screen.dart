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
  bool errorOccurred=false;
  bool showPassword=false;
  bool showConfirmPassword=false;

  String email = '';
  String password = '';

  Widget _buildTextHelp(String text){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 13, bottom: 5, top: 6),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).unselectedWidgetColor,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  Widget _buildEmail(){
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 16),
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Email Id',
          labelStyle: TextStyle(fontSize: 22),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter an Email ID!';
        }
        if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
          return 'Email format not valid!';
        }
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
              errorStyle: TextStyle(color: Colors.red, fontSize: 16),
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
            if (value.length<=6){
              return 'Password length should be more than 6';
            }
            return null;
          },
          onSaved: (String value) {
            password= value;
          },
          onChanged: (String value){
            setState(() {
              password=value;
            });
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

  Widget _buildConfirmPassword(){
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(15, 15,15, 15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2, style: BorderStyle.solid, ),
                borderRadius: BorderRadius.all(Radius.circular(17.0)),
              ),
              errorStyle: TextStyle(color: Colors.red, fontSize: 16),
              fillColor: Theme.of(context).colorScheme.surface,
              labelText: 'Confirm Password',
              labelStyle: TextStyle(fontSize: 22),
              floatingLabelBehavior: FloatingLabelBehavior.never
          ),
          obscureText: !showConfirmPassword,
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
          validator: (String value) {
            if (value!=password) {
              return 'Passwords do not match!';
            }
            return null;
          },
        ),
        Container(
          margin: EdgeInsets.only(right: 15),
          alignment: Alignment.centerRight,
          height: 60,
          child: InkWell(
              onTap: (){
                setState(() {
                  showConfirmPassword=!showConfirmPassword;
                });
              },
              child: Icon(showConfirmPassword?Icons.visibility:Icons.visibility_off,)
          ),
        ),
      ],
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
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
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
                  SizedBox(height:20),
                  _buildTextHelp('Email Id'),
                  _buildEmail(),
                  SizedBox(height:3),
                  _buildTextHelp('Password (minimum 7 characters)'),
                  _buildPassword(),
                  SizedBox(height:10),
                  _buildConfirmPassword(),
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
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
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
                        errorOccurred=false;
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
                          errorOccurred=true;
                        });
                      }
                    },
                  ),
                  errorOccurred? Text(
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
        ),
      ),
    );
  }
}
