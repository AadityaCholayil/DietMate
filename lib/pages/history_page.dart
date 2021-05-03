import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/conversion.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
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

  ListView buildListView(FoodListDay foodList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: foodList.list.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i){
        Food food = foodList.list[i];
        return buildCard(food);
      },
    );
  }

  InkWell buildCard(Food food) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) => foodInfoDialog(food));
      },
      child: GlassContainer(
        borderRadius: BorderRadius.all(Radius.circular(34.0)),
        color: Theme.of(context).cardColor.withOpacity(0.55),
        borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
        height:107,
        width: MediaQuery.of(context).size.width,
        //isFrostedGlass: true,
        //frostedOpacity: 0.05,
        blur: 5,
        margin: EdgeInsets.only(bottom: 13),
        child:Container(
          padding: EdgeInsets.all(6),
          height: 107,
          //color: Colors.white10,
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
                      '${food.name.length>20?food.name.substring(0,16)+"..":food.name}',
                      style: TextStyle(
                          fontSize:26,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    //SizedBox(height: 1),
                    Text(
                      'Calories: ${food.calories} Kcal',
                      style:TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    //SizedBox(height: 1),
                    Text(
                      'Time: ${food.time}',
                      style:TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
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
    User user = Provider.of<User>(context);
    UserData userData = Provider.of<UserData>(context);
    DateTime joinDate = stringToDate(userData.joinDate);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mid_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.0625),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(50,37,0,16),
                alignment: Alignment.centerLeft,
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              GlassContainer(
                borderRadius: BorderRadius.all(Radius.circular(34.0)),
                color: Theme.of(context).cardColor.withOpacity(0.5),
                borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
                height: _format == CalendarFormat.month?425:_format == CalendarFormat.week?160:220,
                width: MediaQuery.of(context).size.width*0.875,
                isFrostedGlass: true,
                frostedOpacity: 0.01,
                blur: 15,
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
                      fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500
                    ),
                    weekendStyle: TextStyle(
                    fontSize: 20,
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
                    outsideTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface ),
                    disabledTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).disabledColor,fontWeight: FontWeight.w600),
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
                    titleTextStyle: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.lightGreen[600],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    formatButtonTextStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:25, top: 13, bottom: 10),
                child: Text(
                  "${dateToString(_selectedDay)}'s food",
                  style: TextStyle(
                      fontSize: 26,
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
                      child: buildListView(foodList)
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
