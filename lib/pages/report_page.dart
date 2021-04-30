import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food_list_week.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/gradient.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Card _buildLineChart() {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(54)),
      color: Colors.grey.shade100.withOpacity(0.1),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            height: 300 ,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            width: double.infinity,


            child: LineChart(

              LineChartData(
                minX:0,
                maxX:8,
                minY: 0,
                maxY: 12,

                borderData: FlBorderData(
                    show: false,
                ),
                titlesData: FlTitlesData(

                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 15,
                    getTextStyles: (value) => const TextStyle(
                      color: Colors.white,
                    )
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 5,
                    getTextStyles: (value) => const TextStyle(
                      color: Colors.white,
                    )
                  )
                ),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                ),

                // backgroundColor: Colors.blueGrey[200],



                lineBarsData: [
                  LineChartBarData(

                    spots:[
                      FlSpot(0, 0),
                      FlSpot(2, 5),
                      FlSpot(3, 6),
                      FlSpot(4, 8),
                      FlSpot(5, 11),
                      FlSpot(6, 4),
                      FlSpot(7, 1),

                    ] ,
                    isCurved: true,
                    curveSmoothness: 0.34,
                    barWidth: 4,
                    belowBarData: BarAreaData(
                      show: true,
                      colors:[
                        Colors.purpleAccent[100],
                        Colors.purpleAccent[700],
                      ]
                    ),
                    colors: [
                      Colors.purpleAccent,
                    ],

                  ),
                ],

              ),

              swapAnimationDuration: Duration(seconds: 1),
              swapAnimationCurve: Curves.linear,
            ),
          ),
        ),
      ),
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 36, left: 38),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Report',
                            style: TextStyle(
                              fontSize: 30,
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
                            ),
                          ),
                        ),
                        _buildLineChart(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              margin: EdgeInsets.zero,
                              child: Container(
                                width: 144,
                                height: 212,
                                // FOR LEGENDS

                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            Card(
                              margin: EdgeInsets.zero,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal:21 ,vertical: 16),
                                height: 212,
                                width: 222,
                                child: PieChart(
                                  PieChartData(
                                    sections:[
                                      PieChartSectionData(
                                        value: data.totalFats.toDouble(),
                                      ),
                                      PieChartSectionData(
                                        value: data.totalCarbs.toDouble(),
                                        color: Colors.blueGrey,
                                      ),
                                      PieChartSectionData(
                                        value: data.totalProtein.toDouble(),
                                        color: Colors.green,
                                      )
                                    ]
                                  ),
                                ),
                              ),
                            )
                          ],
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
