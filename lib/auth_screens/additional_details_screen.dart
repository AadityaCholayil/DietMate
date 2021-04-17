import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:flutter/material.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  @override
  _AdditionalDetailsScreenState createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {

  String _name ='XYZ';
  int _age = 19;
  bool _isMale = true;
  int _height = 170;
  int _weight = 60;
  double _activityLevel = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Additional Details Page',
              style: TextStyle(
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              child:  Text(
                'Next',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: (){
                UserData userData = UserData(
                  name: _name,
                  age: _age,
                  isMale: _isMale,
                  height: _height,
                  weight: _weight,
                  activityLevel: _activityLevel
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => PlanScreen(userData: userData)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
