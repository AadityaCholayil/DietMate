import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';

class FoodListWeek{

  List<FoodListDay> weekList = [];
  int consumedCalories=0;
  int totalFats=0;
  int totalProtein=0;
  int totalCarbs=0;

  FoodListWeek.fromSnapshot(QuerySnapshot snapshot, DateTime start){
    List<DocumentSnapshot> documents = snapshot.docs;
    int i=0;
    DateTime date = start;
    for(int j=0;j<7;j++){
      weekList.add(FoodListDay(list: []));
    }
    for (DocumentSnapshot doc in documents){
      Food food = Food(
        date: doc.data()['date'],
        time: doc.data()['time'],
        timestamp: doc.data()['timestamp'],
        name: doc.data()['name'],
        calories: doc.data()['calories'],
        fats: doc.data()['fats'],
        protein: doc.data()['protein'],
        carbohydrates: doc.data()['carbohydrates'],
        servingSizeQty: doc.data()['servingSizeQty'],
        servingSizeUnit: doc.data()['servingSizeUnit'],
        fullUrl: doc.data()['fullUrl'],
        thumbnailUrl: doc.data()['thumbnailUrl'],
        imageWidth: doc.data()['imageWidth'],
        imageHeight: doc.data()['imageHeight'],
      );
      Timestamp docTimestamp = doc.data()['timestamp'];
      DateTime docDate = docTimestamp.toDate();
      while (date.day != docDate.day) {
        i++;
        date = date.add(Duration(days: 1));
      }
      weekList[i].list.add(food);
    }
    printDetails();
  }

  void printDetails(){
    for(FoodListDay day in weekList){
      print('Day ${weekList.indexOf(day)+1}:');
      for(Food food in day.list){
        food.printDetails();
      }
    }
  }

}
