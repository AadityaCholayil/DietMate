import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';

class FoodListDay {
  int consumedCalories=0;
  int totalFats=0;
  int totalProtein=0;
  int totalCarbs=0;
  List<Food> list=[];

  FoodListDay(){
    this.list=[];
    this.totalProtein=0;
    this.totalCarbs=0;
    this.totalFats=0;
  }

  FoodListDay.fromSnapshot(QuerySnapshot snapshot){
    final List<DocumentSnapshot> documents = snapshot.docs;
    int i=0;
    for (DocumentSnapshot document in documents){
      print(document.reference.id);
      list.add(Food(
        uid: document.reference.id,
        date: document.data()['date'],
        time: document.data()['time'],
        timestamp: document.data()['timestamp'],
        name: document.data()['name'],
        calories: document.data()['calories'],
        fats: document.data()['fats'],
        protein: document.data()['protein'],
        carbohydrates: documents[i].data()['carbohydrates'],
        servingSizeQty: documents[i].data()['servingSizeQty'],
        servingSizeUnit: documents[i].data()['servingSizeUnit'],
        fullUrl: documents[i].data()['fullUrl'],
        thumbnailUrl: documents[i].data()['thumbnailUrl'],
        imageWidth: documents[i].data()['imageWidth'],
        imageHeight: documents[i].data()['imageHeight'],
      ));
      consumedCalories=consumedCalories+documents[i].data()['calories'];
      totalFats=totalFats+documents[i].data()['fats'];
      totalProtein=totalProtein+documents[i].data()['protein'];
      totalCarbs=totalCarbs+documents[i].data()['carbohydrates'];
      i++;
    }

  }



}