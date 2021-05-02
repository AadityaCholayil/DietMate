import 'package:dietmate/model/user.dart';
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

  @override
  Widget build(BuildContext context) {

    UserData userData = Provider.of<UserData>(context);
    DateTime joinDate = DateTime(int.tryParse(userData.joinDate.substring(6,10)),
                                int.tryParse(userData.joinDate.substring(3,5)),
                                int.tryParse(userData.joinDate.substring(0,2)));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mid_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
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
              width: 360,
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
                    selectedDecoration: BoxDecoration(
                      color: Colors.lightGreen[600],
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
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
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.lightGreen[600],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
