import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/auth_screens/additional_details_screen.dart';
import 'package:dietmate/auth_screens/login_screen.dart';
import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/auth_screens/signup_screen.dart';
import 'package:dietmate/auth_screens/auth_screen.dart';
import 'package:dietmate/model/food_list_week.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
                'Debug Page',
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
              ElevatedButton(
                child: Text('Firebase Query'),
                onPressed: () async {
                  DateTime now = DateTime.now();
                  DateTime start = now.subtract(Duration(days: 6));
                  now = DateTime(now.year, now.month, now.day, 23, 59);
                  start = DateTime(start.year, start.month, start.day, 0, 0);

                  FirebaseFirestore db = FirebaseFirestore.instance;
                  QuerySnapshot result = await db.collection('users').doc(user.uid)
                        .collection('foods')
                        .orderBy('timestamp')
                        .startAt([Timestamp.fromDate(start)])
                        .endAt([Timestamp.fromDate(now)])
                        .get();
                  print(result.docs.length);
                  FoodListWeek week = FoodListWeek.fromSnapshot(result, start);
                },
              ),
            ],
          )
      ),
    );
  }
}
