import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/form_pages/image_search_page.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
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

  //ScrollController controller = ScrollController();
  //bool closeTopContainer = false;
  //double topContainer = 0;

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
                  child:Text("${consumedCalories.toInt()}" ,
                    style: TextStyle(
                      fontSize: 62,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0,0,20,5),
                  child: Text(
                    '/${caloriesGoal.toInt()}' ,
                    style: TextStyle(
                      fontSize: 29,
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
                'KCal',
                style: TextStyle(
                  fontSize: 32,
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
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(34),
      ),
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



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    caloriesGoal=userData.calorieGoal;
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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:27.0),
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
                    totalCarb=foodList.totalCarb;
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
                                  color: Colors.white
                              ),
                            ),
                          ),
                          Card(
                            color: Theme.of(context).cardColor,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(54.0))
                            ),
                            child: Container(
                              height:370,
                              alignment:Alignment.center,
                              child: buildSleekCircularSlider()
                            ),
                          ),
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
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: foodList.list.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int i){
                              Food food = foodList.list[i];
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(34)
                                ),
                                margin: EdgeInsets.only(bottom: 13),
                                child:Container(
                                  padding: EdgeInsets.all(6),
                                  height: 107,
                                  color: Colors.white10,
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
                                              '${food.name.length>20?food.name.substring(0,18)+"..":food.name}',
                                              style: TextStyle(
                                                  fontSize:26
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Calories: ${food.calories} Kcal',
                                              style:TextStyle(
                                                fontSize: 20
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Time: ${food.time}',
                                              style:TextStyle(
                                                  fontSize: 20
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
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
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
          ),
        ],

      ),
    );
  }
}
