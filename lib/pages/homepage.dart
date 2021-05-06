import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/form_pages/food_form_final.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/conversion.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    dateToday=dateToString(now);
  }

  Widget buildSleekCircularSlider() {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(54)),
      child: Container(
        alignment:Alignment.center,
        height:370,
        child: SleekCircularSlider(
          min: 0,
          max: caloriesGoal.toDouble(),
          initialValue: consumedCalories<=caloriesGoal?consumedCalories.floorToDouble():caloriesGoal.toDouble(),
          appearance: CircularSliderAppearance(
            // infoProperties: InfoProperties(
            //   topLabelText: '1200',
            // ),
            startAngle: 270,
            angleRange: 360,
            size: 300,
            customWidths: CustomSliderWidths(
              trackWidth: 25.0,
              progressBarWidth: 25.0,
              handlerSize: 7.0,
            ),
            customColors: CustomSliderColors(
              gradientStartAngle: 180,
              gradientEndAngle: 190,
              progressBarColors: [
                Color( 0xffB5FF48),
                Color( 0xff94FC13),
                Color(0xff05B54B),
              ],
              dynamicGradient: true,
              trackColor: Color( 0xffDBFFAF),
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
                          fontSize: 60,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0,0,0,7),
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
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
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
                  fontWeight: FontWeight.w400
              ),
            ),
            Text(
              bottom ,
              style: TextStyle(
                fontSize: 28,
                color: Theme.of(context).colorScheme.onSurface,
                fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600
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

  ListView buildListView(FoodListDay foodList, User user) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: foodList.list.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i){
        Food food = foodList.list[i];
        return buildCard(food, user);
      },
    );
  }

  InkWell buildCard(Food food, User user) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) => foodInfoDialog(food, user));
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
        child: Container(
          padding: EdgeInsets.all(6),
          height: 107,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left:16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${food.name.length>16?food.name.substring(0,15)+"..":food.name}',
                      style: TextStyle(
                        fontSize:26,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    //SizedBox(height: 1),
                    Text(
                      'Calories: ${food.calories} Kcal',
                      style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    //SizedBox(height: 1),
                    Text(
                      'Time: ${food.time}',
                      style:TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34)
                ),
                height: 95,
                width: 95,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  food.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget foodInfoDialog(Food food, User user){
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
              width: MediaQuery.of(context).size.width*0.9,
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
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FoodFormFinal(food: food))
                        );
                      });
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
                    onPressed: () async {
                      await DatabaseService(uid: user.uid).deleteFood(food);
                      Navigator.pop(context);
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
    Size size = MediaQuery.of(context).size;
    print(MediaQuery.of(context).size.width);

    return Scaffold(
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.vertical(bottom: Radius.elliptical(90, 40)),
                ),
                elevation: 8,
                child: Container(
                  height: size.height*0.4,
                  width: size.width,
                  color: Theme.of(context).accentColor,
                  child: SizedBox(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.0625),
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
                              padding: EdgeInsets.fromLTRB(20,47,0,11),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Hello, ${userData.name}',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff176607),
                                ),
                              ),
                            ),
                            buildSleekCircularSlider(),
                            SizedBox(height: 10),
                            buildOtherMetrics(),
                            SizedBox(height: 25),
                            Padding(
                              padding: EdgeInsets.only(left:25),
                              child: Text(
                                "Today's Food",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            buildListView(foodList, user),
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
        ),
      ),
    );
  }
}
