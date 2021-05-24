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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Auth_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 300,0,5),
                // child: GradientText(
                //   'DietMate',
                //   size:50.0,
                //   fontWeight: FontWeight.bold,
                // ),
                child: Text(
                  'DietMate',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0,0,0,30),
                child: Text(
                  'Healthier, Happier Lifestyle!',
                  style: TextStyle(
                    color: Color(0xff176607),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              GradientButton(
                expanded:true,
                extraPaddingHeight:5.0,
                label: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize:23.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                radius: 25,
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
                extraPaddingHeight: 5.0,
                expanded:true,
                label: Text('Sign up',
                  style: TextStyle(
                    fontSize:23.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                radius: 25,
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
        padding: EdgeInsets.all(25.0),
      ),

    );
  }
}
