import 'package:dietmate/auth_pages/additional_details_page.dart';
import 'package:dietmate/auth_pages/login_page.dart';
import 'package:dietmate/auth_pages/plan_page.dart';
import 'package:dietmate/auth_pages/signup_page.dart';
import 'package:dietmate/auth_pages/start_page.dart';
import 'package:flutter/material.dart';

class NeerajTemp extends StatefulWidget {
  @override
  _NeerajTempState createState() => _NeerajTempState();
}

class _NeerajTempState extends State<NeerajTemp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Auth Temp page\n(Neeraj)',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text('Start Page(1)'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => StartPage()),
                ),
              ),
              ElevatedButton(
                child: Text('Sign up Page(2a)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => SignUpPage()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Login Page(2)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Additional Details(2b)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => AddDetailsPage()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Plan Page(2c)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => PlanPage()),
                  );
                },
              ),
            ],
          )
      ),
    );
  }
}
