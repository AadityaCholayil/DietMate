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
  int _customCalorieGoal;
  int selectedIndex=0;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildCard(BuildContext context, int index) {
    String title, subTitle;
    int calGoal;
    double calGoal2;
    String lossPercentage;

    switch(index){
      case 1:{
        title='Mild weight gain';
        subTitle='+0.25 kg/week';
        calGoal2=widget.caloriePlan['gain'];
        lossPercentage='110%';
      }
      break;
      case 2:{
        title='Maintain weight';
        subTitle='';
        calGoal2=widget.caloriePlan['maintain'];
        lossPercentage='100%';
      }
      break;
      case 3:{
        title='Mild weight loss';
        subTitle='-0.25 kg/week';
        calGoal2=widget.caloriePlan['mildLoss'];
        lossPercentage='90%';
      }
      break;
      case 4:{
        title='Weight loss';
        subTitle='-0.5 kg/week';
        calGoal2=widget.caloriePlan['weightLoss'];
        lossPercentage='79%';
      }
      break;
      case 5:{
        title='Extreme weight loss';
        subTitle='-1 kg/week';
        calGoal2=widget.caloriePlan['extLoss'];
        lossPercentage='59%';
      }
      break;
    }
    calGoal=calGoal2.round();
    return InkWell(
      onTap:(){
        setState(() {
          selectedIndex=index;
          _calorieGoal=calGoal;
          _customCalorieGoal=null;
          print(_calorieGoal);
        });
      },
      child: Container(
        width:MediaQuery.of(context).size.width*1,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
            width: selectedIndex==index?3:0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Card(
          color: Theme.of(context).cardColor,
          shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ) ,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            height: 80,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize:MainAxisSize.max,
              children: [
                SizedBox(width: 5,),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title',
                          style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        index!=2?Text(
                          '$subTitle',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ):SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(thickness: 2, color:Theme.of(context).primaryColorLight),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize:MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$calGoal',
                                  style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, bottom: 2),
                                  child: Text(
                                    '$lossPercentage',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              'Calories/day',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustom(){
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 16, 15, 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 0.4, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(17.0)),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Eg. 2200 KCal',
          labelStyle: TextStyle(fontSize: 23),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w300),
      onChanged: (value){
        setState(() {
          selectedIndex=0;
          _customCalorieGoal=int.tryParse(value);
          print(_customCalorieGoal);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
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
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  buildCard(context,1),
                  SizedBox(height: 5),
                  buildCard(context,2),
                  SizedBox(height: 5),
                  buildCard(context,3),
                  SizedBox(height: 5),
                  buildCard(context,4),
                  SizedBox(height: 5),
                  buildCard(context,5),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Divider(color: Theme.of(context).primaryColor,thickness: 2,)
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Divider(color: Theme.of(context).primaryColor,thickness: 2,)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      'Create a Custom Plan',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  _buildCustom(),
                  loading?LoadingSmall():Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      child:  Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () async {
                        UserData newUserData = widget.userData;
                        print("url: ${newUserData.userProfileUrl}");
                        newUserData.calorieGoal=_customCalorieGoal??_calorieGoal;
                        setState(() => loading = true);
                        await DatabaseService(uid: user.uid).updateUserData(newUserData);
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
          ),
        ),
      ),
    );
  }
}
