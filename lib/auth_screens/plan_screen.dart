import 'package:dietmate/home_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatefulWidget {

  final UserData userData;

  PlanScreen({this.userData});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {

  int _calorieGoal=2000;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plan Page',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            loading?LoadingSmall():ElevatedButton(
              child:  Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                UserData newUserData = widget.userData;
                newUserData.calorieGoal=_calorieGoal;
                setState(() => loading = true);
                await DatabaseService(uid: user.uid).updateUserData(newUserData);
                //TODO add safety
                setState(() {
                  loading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => HomeScreen())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
