import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food_list_week.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/conversion.dart';
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
  DateTime now, start, end;

  Future<QuerySnapshot> getData(User user) async {
    now = DateTime.now();
    if (start==null) {
      start = now.subtract(Duration(days: 6));
      start = DateTime(start.year, start.month, start.day, 0, 0);
      end = DateTime(now.year, now.month, now.day, 23, 59);
    }
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot result = await db.collection('users').doc(user.uid)
        .collection('foods')
        .orderBy('timestamp')
        .startAt([Timestamp.fromDate(start)])
        .endAt([Timestamp.fromDate(end)])
        .get();
    return result;
  }
  bool isCalorieDataZero(FoodListWeek data){
    var isZero = true;

  for (var elements in data.weekList ) {
    if(elements.consumedCalories > 0){
      return false;
    }
   };
  return true;
  }
  bool isFatsDataZero(FoodListWeek data){
    var isZero = true;

  for (var elements in data.weekList ) {
    if(elements.totalFats > 0){
      return false;
    }
   };
  return true;
  }
  bool isCarbsDataZero(FoodListWeek data){
    var isZero = true;

  for (var elements in data.weekList ) {
    if(elements.totalCarbs > 0){
      return false;
    }
   };
  return true;
  }
  bool isProteinDataZero(FoodListWeek data){
    var isZero = true;

  for (var elements in data.weekList ) {
    if(elements.totalProtein > 0){
      return false;
    }
   };
  return true;
  }

  Widget noDataAvailable(){
    return Container(
      alignment: Alignment.center,
          child: Text(
            'No Data Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
  }

  Widget _buildLineChart(FoodListWeek data) {

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(54))
      ),
      child: Container(
        height: 300 ,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5, 25, 35, 10),
        margin: EdgeInsets.all(10),
        child: isCalorieDataZero(data) ?
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: noDataAvailable(),

        ):
        LineChart(
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
                getTitles: (i){
                  i--;
                  return (start.add(Duration(days: i.toInt())).day).toString();
                },
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
                titleText: 'Dates',
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(31))
      ),
      color: Theme.of(context).cardColor,
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
          SizedBox(
                height: 10,
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
                  )
                ),
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
          SizedBox(
                height: 10,
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

  List<PieChartSectionData> getPieChartData(FoodListWeek data){
    List<PieChartSectionData> list = [];
    var fatPieCHart = PieChartSectionData(
      title: '${data.totalFats}g' ,
      titleStyle: TextStyle(
        fontSize: 18,
       ),
      titlePositionPercentageOffset: 0.7,
      radius: 90,
      value: data.totalFats.toDouble(),
      color: Color(0xFF94FC13),
      );

    var proteinPieChart = PieChartSectionData(
      title: '${data.totalProtein}g',
      titleStyle: TextStyle(
        fontSize: 18,
       ),
      radius: 90,
      titlePositionPercentageOffset: 0.7,
      value: data.totalProtein.toDouble(),
      color: Color(0xFF22A806),
    );

    var carbPieChart = PieChartSectionData(
      title: '${data.totalCarbs}g',
      titleStyle: TextStyle(
        fontSize: 18,
       ),
      radius: 90,
      titlePositionPercentageOffset: 0.7,
      value: data.totalCarbs.toDouble(),
      color: Color(0xFF176607),
    );
    if (isFatsDataZero(data)!=true){
      list.add(fatPieCHart);
    }
    if (isProteinDataZero(data)!=true){
      list.add(proteinPieChart);
    }
    if (isCarbsDataZero(data)!=true){
      list.add(carbPieChart);
    }
    return list;
  }

  Widget _buildPieChart(FoodListWeek data) {
      return Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(31)) ,
        ),
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal:21 ,vertical: 16),
          height: 212,
          width: MediaQuery.of(context).size.width,
          child:
          isFatsDataZero(data) && isProteinDataZero(data) && isCarbsDataZero(data)?
         noDataAvailable():
          PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sectionsSpace: 2.5,
              sections: getPieChartData(data),
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
    return list;
  }

  Widget _buildBarChart(FoodListWeek data,int type) {

    String label='';
    double maximumY = 0;
    bool isZero = true;
    // Color titleColor ;
    //1 for Fats 2 for Protein 3 for carbs
    switch(type){
      case 1:{
        isZero = isFatsDataZero(data);
        label = 'Total Fats';
        maximumY = double.tryParse((data.maxFatsOfDay()/4).toStringAsPrecision(1)) ;
        // titleColor = Color(0xFF94FC13) ;
      }
      break;
      case 2:{
        isZero = isProteinDataZero(data);
        label = 'Total Protein';
        maximumY = double.tryParse((data.maxProteinOfDay()/4).toStringAsPrecision(1));
        // titleColor = Color(0xFF22A806) ;
      }
      break;
      case 3:{
        isZero = isCarbsDataZero(data);
        label = 'Total Carbs';
        maximumY = double.tryParse((data.maxCarbOfDay()/0.7).toStringAsPrecision(1));
        // titleColor = Color(0xFF176607);
      }
      break;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(31))
      ),
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      child: Container(
      padding: EdgeInsets.fromLTRB(0, 25, 30, 5),
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      height:170,
      width: MediaQuery.of(context).size.width*0.9,
      child: isZero ?
      Container(
          padding: EdgeInsets.fromLTRB(22, 0, 0, 22),
          child: noDataAvailable()
      ):
      BarChart(
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
                titleText: 'Dates',
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
                reservedSize: 15,
                getTextStyles: (value) => TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              bottomTitles: SideTitles(
                getTitles: (i){
                  i--;
                  return (start.add(Duration(days: i.toInt())).day).toString();
                },
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
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    caloriesGoal=userData.calorieGoal;

    return Scaffold(
        body: Container(
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
                  return Stack(
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius:  BorderRadius.vertical(bottom: Radius.elliptical(90, 40)),
                        ),
                        elevation: 8,
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.4,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).accentColor,
                          child: SizedBox(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 7),
                                  margin: EdgeInsets.only(bottom: 5, left: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    // padding: EdgeInsets.only(bottom: 10, left: 5),
                                    icon: Icon(Icons.arrow_back_ios),
                                    iconSize: 25,
                                    color: Colors.black,
                                    onPressed: () {
                                      DateTime joinDate = stringToDate(userData.joinDate);
                                      if(joinDate.isBefore(end.subtract(Duration(days: 7)))){
                                        setState(() {
                                          start=start.subtract(Duration(days: 7));
                                          end=end.subtract(Duration(days: 7));
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 36),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Report',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.only(top: 38),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${ formattedDate(start)} - ${formattedDate(end)}',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Spacer(),
                                Container(
                                  alignment: Alignment.center,
                                  // padding: EdgeInsets.only(right: 5),
                                  margin: EdgeInsets.only(bottom: 5, right: 5,),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    // padding: EdgeInsets.only(bottom: 10, left: 5),
                                    icon: Icon(Icons.arrow_forward_ios),
                                    iconSize: 25,
                                    color: Colors.black,
                                    onPressed: () {
                                      if(now.isAfter(end.add(Duration(days: 6)))){
                                        setState(() {
                                          start=start.add(Duration(days: 7));
                                          end=end.add(Duration(days: 7));
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
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
                      ),
                    ]
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
