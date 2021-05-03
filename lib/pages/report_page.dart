import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/food_list_week.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/gradient.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String weekNo = '';
  int caloriesGoal=0;
  DateTime now, start;

  Future<QuerySnapshot> getData(User user) async {
    now = DateTime.now();
    start = now.subtract(Duration(days: 6));
    now = DateTime(now.year, now.month, now.day, 23, 59);
    start = DateTime(start.year, start.month, start.day, 0, 0);

    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot result = await db.collection('users').doc(user.uid)
        .collection('foods')
        .orderBy('timestamp')
        .startAt([Timestamp.fromDate(start)])
        .endAt([Timestamp.fromDate(now)])
        .get();
    return result;
  }

  Widget _buildLineChart(FoodListWeek data) {
    return GlassContainer(
      borderRadius: BorderRadius.all(Radius.circular(54.0)),
      color: Theme.of(context).cardColor.withOpacity(0.6),
      borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
      height:300,
      width: MediaQuery.of(context).size.width,
      isFrostedGlass: true,
      frostedOpacity: 0.05,
      blur: 15,

      child: Container(
        height: 400 ,
        padding: EdgeInsets.fromLTRB(5, 25, 35, 10),
        margin: EdgeInsets.all(10),
        width: double.infinity,
        child: LineChart(
          LineChartData(
            maxY: data.maxCalOfDay().toDouble(),
            maxX: 7,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                tooltipPadding: EdgeInsets.all(10),
                fitInsideVertically: true,
                // showOnTopOfTheChartBoxArea: true,
              ),
              touchCallback: (LineTouchResponse touchRespone){},
              handleBuiltInTouches: true,
            ),
            gridData: FlGridData(
              drawHorizontalLine: false,
              drawVerticalLine: true,
            ),
            borderData: FlBorderData(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
            ),
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                interval: double.tryParse((data.maxCalOfDay()/7).toStringAsPrecision(1)),
                reservedSize: 30,
                getTextStyles: (value) => TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 5,
                getTextStyles: (value) => TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )
              )
            ),
          // backgroundColor: Colors.blueGrey[200],
            axisTitleData: FlAxisTitleData(
              leftTitle: AxisTitle(
                showTitle: true,
                titleText: 'Calories',
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface
                ),
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'Days',
                margin: 15,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface
                ),
              )
            ),
            lineBarsData: [
              LineChartBarData(
                spots:[
                  FlSpot(1, data.weekList[0].consumedCalories.toDouble()),
                  FlSpot(2, data.weekList[1].consumedCalories.toDouble()),
                  FlSpot(3, data.weekList[2].consumedCalories.toDouble()),
                  FlSpot(4, data.weekList[3].consumedCalories.toDouble()),
                  FlSpot(5, data.weekList[4].consumedCalories.toDouble()),
                  FlSpot(6, data.weekList[5].consumedCalories.toDouble()),
                  FlSpot(7, data.weekList[6].consumedCalories.toDouble()),
                ] ,
                 colors: [
                  Theme.of(context).accentColor,
                ],
                isCurved: true,
                curveSmoothness: 0.45,
                preventCurveOverShooting: true,
                preventCurveOvershootingThreshold: 0,
                barWidth: 3,

                // belowBarData: BarAreaData(
                //   show: true,
                //   colors:[
                //     Colors.purpleAccent[100],
                //     Colors.purpleAccent[200],
                //     Colors.purpleAccent[700],
                //   ]
                // ),
              ),
            ],

          ),

          swapAnimationDuration: Duration(seconds: 1),
          swapAnimationCurve: Curves.linear,
        ),
      ),
    );
  }

  Widget _buildLegends(FoodListWeek data) {
    return GlassContainer(
    borderRadius: BorderRadius.all(Radius.circular(31.0)),
    color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
    borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
    height:212,
    width:144,
    isFrostedGlass: true,
    frostedOpacity: 0.05,
    blur: 12,
    margin: EdgeInsets.zero,
    child: Container(
      width: 144,
      height: 212,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Fats',
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 18,
              ),
                SizedBox(
                  width: 17,
                  height: 16,
                  child: const DecoratedBox(
                        decoration: const BoxDecoration(
                        color: Color(0xFF94FC13),
                  )),
                ),
                SizedBox(
                  width: 10,
                ),
                    Text(
                      '${data.totalFats}g',
                      style: TextStyle(
                        fontSize: 26,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
          Text(
            'Total Protein',
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
               SizedBox(
                width: 18,
              ),
                SizedBox(
                width: 17,
                height: 16,
                child: const DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFF22A806),
                    )),
          ),
          SizedBox(
            width: 10,
          ),
              Text(
                '${data.totalProtein}g',
                style: TextStyle(
                  fontSize: 26,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            'Total Carbs',
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Row(

            children: [
               SizedBox(
                width: 18,
              ),
              SizedBox(
                width: 17,
                height: 16,
                child: const DecoratedBox(
                      decoration: const BoxDecoration(
                      color: Color(0xFF176607),

                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                  '${data.totalCarbs}g',
                  style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildPieChart(FoodListWeek data) {
      return GlassContainer(
      borderRadius: BorderRadius.all(Radius.circular(31.0)),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
      borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
      height:212,
      width:222,
      isFrostedGlass: true,
      frostedOpacity: 0.05,
      blur: 12,
      margin: EdgeInsets.zero,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal:21 ,vertical: 16),
          height: 212,
          width: 222,
          child: PieChart(
            PieChartData(

              centerSpaceRadius: 0,
              sectionsSpace: 2.5,
              sections:[
                PieChartSectionData(
                  title: '${data.totalFats}g' ,
                  titleStyle: TextStyle(
                    fontSize: 18,
                  ),
                  titlePositionPercentageOffset: 0.7,
                  radius: 90,
                  value: data.totalFats.toDouble(),
                  color: Color(0xFF94FC13),

                ),

                PieChartSectionData(
                  title: '${data.totalProtein}g',
                  titleStyle: TextStyle(
                    fontSize: 18,
                  ),
                  radius: 90,
                  titlePositionPercentageOffset: 0.7,
                  value: data.totalProtein.toDouble(),
                  color: Color(0xFF22A806),
                ),

                PieChartSectionData(
                  title: '${data.totalCarbs}g',
                  titleStyle: TextStyle(
                    fontSize: 18,
                  ),
                  radius: 90,
                  titlePositionPercentageOffset: 0.7,
                  value: data.totalCarbs.toDouble(),
                  color: Color(0xFF176607),
                ),
              ]
            ),
          ),
        ),
      );
    }

  List <BarChartGroupData> generateBarData(FoodListWeek data, int type){
    //1 for Fats 2 for Protein 3 for carbs
    List <BarChartGroupData> list = [];
    switch(type){
      case 1:{
        for(int i=0; i<7; i++){
          var bar=BarChartGroupData(
                x: i+1,
                barRods: [
                  BarChartRodData(
                    y: data.weekList[i].totalFats.toDouble(),
                    colors:[Color(0xFF94FC13),]
                  ),
                ],
            );
          list.add(bar);
        }
        return list;
      }
      break;
       case 2:{
        for(int i=0; i<7; i++){
          var bar=BarChartGroupData(
                x: i+1,
                barRods: [
                  BarChartRodData(
                    y: data.weekList[i].totalProtein.toDouble(),
                    colors:[Color(0xFF22A806),]
                  )
                ],
            );
          list.add(bar);
        }
        return list;
      }
      break;
       case 3:{
        for(int i=0; i<7; i++){
          var bar=BarChartGroupData(
                x: i+1,
                barRods: [
                  BarChartRodData(
                    y: data.weekList[i].totalCarbs.toDouble(),
                    colors:[Color(0xFF176607),]
                  )
                ],
            );
          list.add(bar);
        }
        return list;
      }
      break;
    }
  }

  Widget _buildBarChart(FoodListWeek data,int type) {

    String label='';
    double maximumY = 0;
    Color titleColor ;
    //1 for Fats 2 for Protein 3 for carbs
    switch(type){
      case 1:{
        label = 'Total Fats';
        maximumY = double.tryParse((data.maxFatsOfDay()/4).toStringAsPrecision(1)) ;
        // titleColor = Color(0xFF94FC13) ;
      }
      break;
      case 2:{
        label = 'Total Protein';
        maximumY = double.tryParse((data.maxProteinOfDay()/4).toStringAsPrecision(1));
        // titleColor = Color(0xFF22A806) ;
      }
      break;
      case 3:{
        label = 'Total Carbs';
        maximumY = double.tryParse((data.maxCarbOfDay()/4).toStringAsPrecision(1));
        // titleColor = Color(0xFF176607);
      }
      break;
    }

    return GlassContainer(
      borderRadius: BorderRadius.all(Radius.circular(31.0)),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
      borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
      height:170,
      width:MediaQuery.of(context).size.width*0.9,
      margin: EdgeInsets.zero,
      isFrostedGlass: true,
      frostedOpacity: 0.05,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 25, 30, 5),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        height:99,
        width: 180,
        child:BarChart(
          BarChartData(
            borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1
                  ),
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  )

                )
            ),


            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                titleText: '$label',
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                margin: 10,
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'Days',
                margin:10,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                interval: maximumY.toDouble(),
                showTitles: true,
                reservedSize: 10,
                getTextStyles: (value) => TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 5,
                getTextStyles: (value) => TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                )
              )
            ),
            gridData: FlGridData(
              drawHorizontalLine: false,
            ),
          barGroups: generateBarData(data, type)
          ),
        ),
      )
    );
  }


  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    caloriesGoal=userData.calorieGoal;

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mid_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
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
                if(snapshot.hasData){
                  FoodListWeek data = FoodListWeek.fromSnapshot(snapshot.data, start);
                  // if(foodList.list.isEmpty){
                  //   //query successful but is empty
                  //   return Container(
                  //     child: Text(
                  //         'Empty'
                  //     ),
                  //   );
                  // }
                  //TODO main code
                  List<FlSpot>spotList=[];

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 36, left: 38),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Report',
                            style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 38),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'of the past 7 days',
                            style: TextStyle(
                              fontSize: 19,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        _buildLineChart(data),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegends(data),

                            SizedBox(
                              width: 10,
                            ),

                            _buildPieChart(data)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _buildBarChart(data,1), //Fats Bar Chart
                        SizedBox(
                          height: 10,
                        ),
                        _buildBarChart(data,2), //Protein Bar Chart
                        SizedBox(
                          height: 10,
                        ),
                        _buildBarChart(data,3), //Carbs Bar Chart
                        SizedBox(
                          height: 90,
                        )
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
        )
    );
  }
}
