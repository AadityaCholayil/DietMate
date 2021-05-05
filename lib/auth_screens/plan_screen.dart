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
            buildCard(context,1),
            buildCard(context,2),
            buildCard(context,3),
            buildCard(context,4),
            buildCard(context,5),
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

  Widget buildCard(BuildContext context, int index) {
    String title, subTitle;
    int calGoal, lossPercentage;
    bool isTrue= false;

    switch(index){
      case 1:{
        title='Mild weight gain';
        subTitle='+0.25 kg/week';
      }
      break;
      case 2:{
        title='Maintain weight';
        subTitle='';
      }
      break;
      case 3:{
        title='Mild weight loss';
        subTitle='-0.25 kg/week';
      }
      break;
      case 4:{
        title='Weight loss';
        subTitle='0.5 kg/week';
      }
      break;
      case 5:{
        title='Extreme weight loss';
        subTitle='1 kg/week';
      }
      break;
    }
    return InkWell(
      onTap:(){},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(20),

        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Card(
          color: Theme.of(context).cardColor,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ) ,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              height: 80,
              child: Column(
                children: [
                  Text(
                    '$title',

                  ),
                ],
              ),


            ),

        ),
      ),
    );
  }
}
