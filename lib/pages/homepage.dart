import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/gradient.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  String dateToday = '';
  double consumedCalories = 0.0;
  double caloriesGoal =0.0;
  double totalFats = 0.0;
  double totalProtein = 0.0;
  double totalCarb = 0.0;

  Future<QuerySnapshot> getData(User user) async {
    return await db.collection('users').doc(user.uid).collection('foods')
        .where('date', isEqualTo: dateToday).get();
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateToday='${now.day}-${now.month}-${now.year}';
  }

  SleekCircularSlider buildSleekCircularSlider() {
    return SleekCircularSlider(
      min: 0,
      max: caloriesGoal,
      initialValue: consumedCalories,
      appearance: CircularSliderAppearance(
        infoProperties: InfoProperties(
          topLabelText: '1200',
        ),
        startAngle: 270,
        angleRange: 360,
        size: 300,
        customWidths: CustomSliderWidths(
          trackWidth: 6.0,
          progressBarWidth: 18.0,
          handlerSize: 15.0,
        ),
        customColors: CustomSliderColors(
          progressBarColors: [
            Colors.purpleAccent[100],
            Colors.deepPurpleAccent[700],
            Colors.purple[700],
            Colors.purpleAccent[400],
            Colors.deepPurpleAccent[400],
            Colors.purpleAccent[400],
            Colors.purple[700],
            Colors.purpleAccent[100],
          ],
          dynamicGradient: true,
          trackColor: Colors.deepPurpleAccent[300],
          hideShadow: true,
        ),
      ),
      innerWidget: (double value) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //padding: EdgeInsets.all(10.0),
                  child:Text("$consumedCalories" ,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0,0,20,5),
                  child: Text(
                    'of' ,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.zero,
              //padding: EdgeInsets.all(5.0),
              child: Text(
                '2200',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget totalMetricInfo(String top, String bottom){
    return Column(
      children: [
        Text(
          top ,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontStyle: FontStyle.normal,
          ),
        ),
        Text(
          bottom ,
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Widget buildOtherMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget>[
        Flexible(
          child: Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(0.0),
            child: totalMetricInfo('Fats', '$totalFats'),
          ),
        ),
        SizedBox(width: 20,),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(0.0),
            child: totalMetricInfo('Protein', '$totalProtein'),
          ),
        ),
        SizedBox(width: 20,),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(0.0),
            child: totalMetricInfo('Carb', '$totalCarb'),
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    caloriesGoal=userData.calorieGoal.toDouble();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.vertical(bottom: Radius.elliptical(90, 50)),
            ),
            elevation: 8,
            child: Container(
              height: height/3,
              width: width,
              decoration: BoxDecoration(
                gradient: customGradient,
              ),
              child: SizedBox(),
            ),
          ),
          Container(
            child: FutureBuilder<QuerySnapshot>(
              future: getData(user),
              builder: (context, snapshot){
                if(snapshot.connectionState!=ConnectionState.done){
                  //query in progress
                  return Loading();
                }
                if(snapshot.hasError){
                  return Container(
                    child: Text(
                      'Error occurred',
                    ),
                  );
                }
                if(snapshot.hasData) {
                  FoodListDay foodList = FoodListDay.fromSnapshot(snapshot.data);
                  consumedCalories=foodList.consumedCalories.toDouble();
                  totalFats=foodList.totalFats;
                  totalProtein=foodList.totalProtein;
                  totalCarb=foodList.totalCarb;
                  if(foodList.list.isEmpty){
                    //query successful but is empty
                    return Container(
                      child: Text(
                          'Empty'
                      ),
                    );
                  }
                  //TODO main code
                  return Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(22, 35, 0, 18),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'DietMate',
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Card(
                          color: Color( 0xff303030 ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(25.0,25.0, 25.0,25.0),
                              child: Column(
                                children: <Widget>[
                                  buildSleekCircularSlider(),
                                  SizedBox(height: 25,),
                                  buildOtherMetrics()
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  child: Text(
                      'Something went wrong'
                  ),
                );
              },
            ),
          ),
        ],

      ),
    );
  }
}
