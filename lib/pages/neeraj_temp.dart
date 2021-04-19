import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/auth_screens/login_screen.dart';
import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/auth_screens/signup_screen.dart';
import 'package:dietmate/auth_screens/auth_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NeerajTemp extends StatefulWidget {
  @override
  _NeerajTempState createState() => _NeerajTempState();
}

class _NeerajTempState extends State<NeerajTemp> {


  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<UserData>(context);

    if(userData==null){
      return Loading();
    }

    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Auth Screens(Temporary)\n(Neeraj)\nGitHub branch',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text('Start Screen(1)'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
                ),
              ),
              ElevatedButton(
                child: Text('Sign up Screen(2a)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Login Screen(2)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Additional Details(2b)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => AdditionalDetailsScreen()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Plan Screen(2c)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => PlanScreen()),
                  );
                },
              ),
            ],
          )
      ),
    );
  }
}
