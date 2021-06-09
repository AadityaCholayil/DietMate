import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/form_pages/food_form_final.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/conversion.dart';
import 'package:dietmate/shared/gradient.dart';
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

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
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

  Widget buildSleekCircularSlider(double width) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(54)),
      child: Container(
        alignment:Alignment.center,
        height: width*0.856,
        child: SleekCircularSlider(
          min: 0,
          max: caloriesGoal.toDouble(),
          initialValue: consumedCalories<caloriesGoal?consumedCalories.floorToDouble():caloriesGoal.toDouble(),
          appearance: CircularSliderAppearance(
            // infoProperties: InfoProperties(
            //   topLabelText: '1200',
            // ),
            startAngle: 270,
            angleRange: 360,
            size: MediaQuery.of(context).size.width*(320/432),
            customWidths: CustomSliderWidths(
              trackWidth: 4.0,
              progressBarWidth: 25.0,
              handlerSize: 7.0,
            ),
            customColors: CustomSliderColors(
              gradientStartAngle: 180,
              gradientEndAngle: 190,
              progressBarColors: consumedCalories>=caloriesGoal?
              <Color>[
                Colors.red,
                Colors.red
              ]:consumedCalories>(caloriesGoal*0.8)?
              <Color>[
                Colors.orange,
                Colors.orange
              ]:<Color>[
                Color( 0xffB5FF48),
                Color( 0xff94FC13),
                Color(0xff05B54B),
              ],
              // progressBarColors: consumedCalories<caloriesGoal?
              // <Color>[
              //   Color( 0xffB5FF48),
              //   Color( 0xff94FC13),
              //   Color(0xff05B54B),
              // ]:consumedCalories>(caloriesGoal*0.8)?
              // <Color>[
              //   Colors.orange,
              //   Colors.orange
              // ]:<Color>[
              //   Colors.red,
              //   Colors.red
              // ],
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

  Widget totalMetricInfo(String top, String bottom, double width){
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
      child: Container(
        height: width*0.185,
        width: width*0.289,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              top ,
              style: TextStyle(
                fontSize:17,
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

  Widget buildOtherMetrics(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget>[
        Flexible(
          child: totalMetricInfo('Fats', '${totalFats}g', width),
        ),
        SizedBox(width: 12,),
        Flexible(
          child: totalMetricInfo('Protein', '${totalProtein}g', width),
        ),
        SizedBox(width: 12),
        Flexible(
          child: totalMetricInfo('Carb', '${totalCarb}g', width),
        ),
      ],
    );
  }

  Widget buildListView(FoodListDay foodList, User user, double width) {
    if(foodList.list.isEmpty){
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Text(
          'No food added yet.',
          style: TextStyle(
            fontSize: 22
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: foodList.list.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i){
        Food food = foodList.list[i];
        return buildCard(food, user, width);
      },
    );
  }

  InkWell buildCard(Food food, User user, double width) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) => foodInfoDialog(food, user));
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
        child: Container(
          padding: EdgeInsets.all(width*0.0092),
          height: width*0.238,
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
                      '${food.name.length>17?food.name.substring(0,15)+"..":food.name}',
                      style: TextStyle(
                        fontSize:23,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    //SizedBox(height: 1),
                    Text(
                      'Calories: ${food.calories} Kcal',
                      style:TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    //SizedBox(height: 1),
                    Text(
                      'Time: ${food.time}',
                      style:TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34)
                ),
                height: width*0.22,
                width: width*0.22,
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
        //height: food.name.length<20?MediaQuery.of(context).size.width*1.46:MediaQuery.of(context).size.width*1.535,
        width: MediaQuery.of(context).size.width*0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: <Widget>[
                  Text(
                    '${food.name}',
                    style: TextStyle(
                      fontSize: 24,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Calories: ${food.calories} Kcal',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Time: ${food.time}',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Protein: ${food.protein}g',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Fats: ${food.fats}g',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height:1),
                  Text(
                    'Carbohydrates: ${food.carbohydrates}g',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    'Serving Size: ${food.servingSizeQty} ${food.servingSizeUnit}',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(bottom: 5,right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Update',
                    style: TextStyle(
                      fontSize:20,
                        fontWeight: FontWeight.w600
                     ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FoodFormFinal(food: food))
                      );
                      setState(() {
                        print('back to homepage');
                      });
                    }
                  ),
                  TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    onPressed: () async {
                      await DatabaseService(uid: user.uid).deleteFood(food);
                      setState(() {
                        print('Deleted!');
                      });
                      Navigator.pop(context);
                    }
                  ),
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize:20,
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
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
                  elevation: 0,
                  child: Container(
                    height: width*0.694,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: customGradient
                    ),
                    // color: Theme.of(context).accentColor,
                    child: SizedBox(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width*0.0625),
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
                                padding: EdgeInsets.fromLTRB(20,40,0,6),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Hello, ${userData.name}',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff176607),
                                  ),
                                ),
                              ),
                              buildSleekCircularSlider(width),
                              SizedBox(height: 10),
                              buildOtherMetrics(width),
                              SizedBox(height: width*0.058),
                              Padding(
                                padding: EdgeInsets.only(left:25),
                                child: Text(
                                  "Today's Food",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              buildListView(foodList, user, width),
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
      ),
    );
  }
}
