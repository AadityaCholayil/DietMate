import 'dart:math';

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
      weekList.add(FoodListDay());
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
    for(int i=0;i<7;i++){
      if (weekList[i].list.isNotEmpty) {
        for(Food food in weekList[i].list){
          weekList[i].consumedCalories=weekList[i].consumedCalories+food.calories;
          weekList[i].totalFats=weekList[i].totalFats+food.fats;
          weekList[i].totalProtein=weekList[i].totalProtein+food.protein;
          weekList[i].totalCarbs=weekList[i].totalCarbs+food.carbohydrates;
        }
      }
      consumedCalories+=weekList[i].consumedCalories??0;
      totalFats+=weekList[i].totalFats;
      totalProtein+=weekList[i].totalProtein;
      totalCarbs+=weekList[i].totalCarbs;
    }
    printDetails();
  }

  void printDetails(){
    print('Fats: $totalFats, Carbs: $totalCarbs, Protein: $totalProtein');
    for(FoodListDay day in weekList){
      print('Day ${weekList.indexOf(day)+1}:');
      for(Food food in day.list){
        food.printDetails();
      }
    }
  }
  int maxCalOfDay(){
    int max=0;
    for(int i = 0; i<7 ;i++){
      if(weekList[i].consumedCalories>max){
        max=weekList[i].consumedCalories;
      }
    }
    return max;
  }
  int maxProteinOfDay(){
    int max=0;
    for(int i = 0; i<7 ;i++){
      if(weekList[i].totalProtein>max){
        max=weekList[i].totalProtein;
      }
    }
    return max;
  }
  int maxFatsOfDay(){
    int max=0;
    for(int i = 0; i<7 ;i++){
      if(weekList[i].totalFats>max){
        max=weekList[i].totalFats;
      }
    }
    return max;
  }
  int maxCarbOfDay(){
    int max=0;
    for(int i = 0; i<7 ;i++){
      if(weekList[i].totalCarbs>max){
        max=weekList[i].totalCarbs;
      }
    }
    return max;
  }

}
