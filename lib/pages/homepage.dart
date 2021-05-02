import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/food_list.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  String dateToday = '';
  int consumedCalories = 0;
  int caloriesGoal = 0;
  int totalFats = 0;
  int totalProtein = 0;
  int totalCarb = 0;

  //ScrollController controller = ScrollController();
  //bool closeTopContainer = false;
  //double topContainer = 0;

  Future<QuerySnapshot> getData(User user) async {
    return await db.collection('users').doc(user.uid).collection('foods')
        .where('date', isEqualTo: dateToday).orderBy('timestamp').get();
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateToday='${now.day}-${now.month}-${now.year}';
  }

  Widget buildSleekCircularSlider() {
    return GlassContainer(
      borderRadius: BorderRadius.all(Radius.circular(54.0)),
      color: Theme.of(context).cardColor.withOpacity(0.55),
      borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
      height:370,
      width: MediaQuery.of(context).size.width,
      //isFrostedGlass: true,
      //frostedOpacity: 0.05,
      blur: 12,
      child: Container(
        alignment:Alignment.center,
        child: SleekCircularSlider(
          min: 0,
          max: caloriesGoal.toDouble(),
          initialValue: consumedCalories.floorToDouble(),
          appearance: CircularSliderAppearance(
            // infoProperties: InfoProperties(
            //   topLabelText: '1200',
            // ),
            startAngle: 270,
            angleRange: 360,
            size: 300,
            customWidths: CustomSliderWidths(
              trackWidth: 3.5,
              progressBarWidth: 25.0,
              handlerSize: 7.0,
            ),
            customColors: CustomSliderColors(
              progressBarColors: [
                Color( 0xffB5FF48),
                Color( 0xff94FC13),
                Color(0xff05B54B),
              ],
              dynamicGradient: true,
              trackColor: Color( 0xffD0EEAC),
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
                      child:Text("${consumedCalories.toInt()}" ,
                        style: TextStyle(
                          fontSize: 62,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0,0,20,5),
                      child: Text(
                        '/${caloriesGoal.toInt()}' ,
                        style: TextStyle(
                          fontSize: 29,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.zero,
                  //padding: EdgeInsets.all(5.0),
                  child: Text(
                    'KCal',
                    style: TextStyle(
                      fontSize: 32,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget totalMetricInfo(String top, String bottom){
    return GlassContainer(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.all(Radius.circular(34.0)),
      color: Theme.of(context).cardColor.withOpacity(0.55),
      borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
      height:80,
      width: 117,
      //isFrostedGlass: true,
      //frostedOpacity: 0.05,
      blur: 11,

      child: Container(
        height: 80,
        width: 117,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              top ,
              style: TextStyle(
                fontSize:19,
                color: Theme.of(context).colorScheme.onSurface,
                fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              bottom ,
              style: TextStyle(
                fontSize: 28,
                color: Theme.of(context).colorScheme.onSurface,
                fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOtherMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget>[
        Flexible(
          child: totalMetricInfo('Fats', '$totalFats'),
        ),
        SizedBox(width: 20,),
        Flexible(
          child: totalMetricInfo('Protein', '$totalProtein'),
        ),
        SizedBox(width: 20),
        Flexible(
          child: totalMetricInfo('Carb', '$totalCarb'),
        ),
      ],
    );
  }

  Widget foodInfoDialog(Food food){
    return Dialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: 630,
        width: MediaQuery.of(context).size.width*0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width*0.9,
              child: Image.network(
                food.fullUrl,
                fit: food.imageWidth>food.imageHeight? BoxFit.fitHeight : BoxFit.fitWidth,
              ),
            ),
            SizedBox(height:5),
            Container(
              padding: EdgeInsets.only(left:12,top: 5),
              width: 400,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: <Widget>[
                  Text(
                    '${food.name}',
                    style: TextStyle(
                      fontSize: 26,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Calories: ${food.calories} Kcal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Time: ${food.time}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Protein: ${food.protein}g',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Fats: ${food.fats}g',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Carbohydrates: ${food.carbohydrates} Kcal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.only(bottom: 5,right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Update',
                    style: TextStyle(
                      fontSize:23,
                        fontWeight: FontWeight.w600
                     ),
                    ),
                    onPressed: () {
                      print('Pressed');
                    }

                  ),
                  TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontSize:23,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                      onPressed: () {
                      print('Pressed');
                    }
                  ),
                  TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize:23,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        print('Pressed');
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    caloriesGoal=userData.calorieGoal;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal:27.0),
        child: SingleChildScrollView(
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
                consumedCalories=foodList.consumedCalories;
                totalFats=foodList.totalFats;
                totalProtein=foodList.totalProtein;
                totalCarb=foodList.totalCarbs;
                // if(foodList.list.isEmpty){
                //   //query successful but is empty
                //   return Container(
                //     child: Text(
                //         'Empty'
                //     ),
                //   );
                // }
                //TODO main code
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(20,47,0,16),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Welcome, ${userData.name}',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      buildSleekCircularSlider(),
                      SizedBox(height: 13),
                      buildOtherMetrics(),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(left:25),
                        child: Text(
                          "Today's food",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      buildListView(foodList, context),
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
      ),
    );
  }
}
