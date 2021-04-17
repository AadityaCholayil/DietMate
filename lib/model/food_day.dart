import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';

class FoodList {
  int consumedCalories=0;
  List<Food> list=[];

  FoodList({this.consumedCalories, this.list});

  FoodList.fromSnapshot(QuerySnapshot snapshot){
    final List<DocumentSnapshot> documents = snapshot.docs;
    int i=0;
    for (DocumentSnapshot document in documents){
      list.add(Food(
        date: document.data()['date'],
        week: document.data()['week'],
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
      i++;
    }
  }



}