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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  CalendarFormat _format = CalendarFormat.month;
  DateTime now = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<QuerySnapshot> getData(User user) async {
    return await db.collection('users')
        .doc(user.uid)
        .collection('foods')
        .where('date', isEqualTo: dateToString(_selectedDay))
        .orderBy('timestamp')
        .get();
  }

  Widget buildListView(FoodListDay foodList, User user, double width) {
    if(foodList.list.isEmpty){
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Text(
          'No food added.',
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
                      '${food.name.length>16?food.name.substring(0,15)+"..":food.name}',
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
        height: food.name.length<20?MediaQuery.of(context).size.width*1.46:MediaQuery.of(context).size.width*1.535,
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
                    'Carbohydrates: ${food.carbohydrates} Kcal',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400
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
    User user = Provider.of<User>(context);
    final Size size = MediaQuery.of(context).size;
    double width = size.width;
    UserData userData = Provider.of<UserData>(context);
    DateTime joinDate = stringToDate(userData.joinDate);
    var uHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children:[
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.vertical(bottom: Radius.elliptical(90, 40)),
              ),
              elevation: 8,


              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                height: _format == CalendarFormat.month ? uHeight*0.4 :( _format == CalendarFormat.twoWeeks ? uHeight*0.25 : uHeight*0.21),
                width: MediaQuery.of(context).size.width,
                // color: Theme.of(context).accentColor,
                child: SizedBox(),
                decoration: BoxDecoration(
                      gradient: customGradient
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0625),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(30,35,0,5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'History',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          // color: Theme.of(context).colorScheme.onSurface,
                          color: Color(0xff176607),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(34.0)),
                      ),
                      color: Theme.of(context).cardColor,
                      child: Container(
                        // duration: Duration(milliseconds: 300),
                        //height: _format == CalendarFormat.month?425:_format == CalendarFormat.week?170:250,
                        padding: EdgeInsets.fromLTRB(15,5,15,15),
                        child: TableCalendar(
                          focusedDay: _focusedDay,
                          firstDay: joinDate,
                          lastDay: now,
                          calendarFormat: _format,
                          onFormatChanged: (CalendarFormat format) {
                            setState(() {
                              _format = format;
                            });
                          },
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          daysOfWeekVisible: true,
                          daysOfWeekHeight: 22,
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontSize: 17,
                                color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500
                            ),
                            weekendStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.red,fontWeight: FontWeight.w500
                            )
                          ),

                          //Day Changed
                          onDaySelected: (DateTime selectDay, DateTime focusDay) {
                            if (!isSameDay(_selectedDay, selectDay)) {
                              setState(() {
                                _selectedDay = selectDay;
                                _focusedDay = selectDay;
                              });
                              print('$_focusedDay, $_selectedDay');
                            }
                          },
                          selectedDayPredicate: (DateTime date) {
                            return isSameDay(_selectedDay, date);
                          },
                          availableGestures: AvailableGestures.horizontalSwipe,
                          //headerVisible: false,
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: true,
                            defaultTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500 ),
                            todayTextStyle:TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w600 ),
                            selectedTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w600 ),
                            //rangeStartTextStyle:TextStyle(fontSize: 20,color: Colors.red ),
                            //rangeEndTextStyle: TextStyle(fontSize: 20,color: Colors.red),
                            outsideTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).disabledColor ),
                            disabledTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).disabledColor,fontWeight: FontWeight.w400),
                            holidayTextStyle: TextStyle(fontSize: 20,color: Colors.red ),
                            weekendTextStyle: TextStyle(fontSize: 20,color: Colors.red ),
                            withinRangeTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w600 ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.lightGreen[600],
                              shape: BoxShape.circle,
                              //borderRadius: BorderRadius.circular(5.0),
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.green[700],
                              shape: BoxShape.circle,
                              //borderRadius: BorderRadius.circular(5.0),
                            ),
                            defaultDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              //borderRadius: BorderRadius.circular(5.0),
                            ),
                            weekendDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              //borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            titleCentered: true,
                            formatButtonShowsNext: false,
                            titleTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500),
                            formatButtonDecoration: BoxDecoration(
                              color: Colors.lightGreen[600],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            formatButtonTextStyle: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:25, top: 13, bottom: 5),
                      child: Text(
                        "${formattedDate(_selectedDay)}'s food",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: getData(user),
                      builder: (context, snapshot){
                        if(snapshot.connectionState!=ConnectionState.done){
                          //query in progress
                          return LoadingSmall(color: Colors.transparent);
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
                          // if(foodList.list.isEmpty){
                          //   //query successful but is empty
                          //   return Container(
                          //     child: Text(
                          //         'Empty'
                          //     ),
                          //   );
                          // }
                          return Container(
                            child: buildListView(foodList, user,width)
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
