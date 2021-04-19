import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:dietmate/model/user.dart';
import 'package:dietmate/shared/gradient.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  String dateToday = '';
  int caloriesGoal=0;

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
          Container(
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
                  FoodListDay foodList = FoodListDay.fromSnapshot(snapshot.data);
                  if(foodList.list.isEmpty){
                    //query successful but is empty
                    return Container(
                      child: Text(
                          'Empty'
                      ),
                    );
                  }
                  //TODO main code
                  return Container(
                    child: Text(
                        'Got data (${foodList.list.length} doc/s)\ncalo=${foodList.consumedCalories}'
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
      )
    );
  }
}
