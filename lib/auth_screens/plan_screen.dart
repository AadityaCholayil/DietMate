import 'package:dietmate/home_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatefulWidget {

  final UserData userData;
  final Map caloriePlan;

  PlanScreen({this.userData, this.caloriePlan});

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
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 25,bottom: 25),
              child: Text(
                'Plans for you',
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
            buildCard(context),
            buildCard(context),
            buildCard(context),
            buildCard(context),
            buildCard(context),
            loading?LoadingSmall():Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }

  Card buildCard(BuildContext context) {
    return Card(
            color: Theme.of(context).cardColor,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ) ,
              clipBehavior: Clip.antiAliasWithSaveLayer,

              child: Container(
                height: 80,


              ),

          );
  }
}
