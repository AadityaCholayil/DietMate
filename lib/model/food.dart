import 'package:cloud_firestore/cloud_firestore.dart';

class Food{
  String uid;
  String date;
  String time;
  Timestamp timestamp;
  String name;
  int calories;
  int fats;
  int carbohydrates;
  int protein;
  int servingSizeQty;
  String servingSizeUnit;
  String fullUrl;
  String thumbnailUrl;
  int imageWidth;
  int imageHeight;

  Food({this.uid, this.date, this.time, this.timestamp, this.name, this.calories, this.fats, this.carbohydrates,
    this.protein, this.servingSizeQty, this.servingSizeUnit, this.fullUrl,
    this.thumbnailUrl, this.imageWidth, this.imageHeight});

  Food.fromAPIData(var data, int hitNo){
    this.name=data["hints"][hitNo]["food"]["item_name"];
    this.calories=data["hints"][hitNo]["food"]["nf_calories"].floor();
    this.fats=data["hints"][hitNo]["food"]["nf_total_fat"].floor();
    this.carbohydrates=data["hints"][hitNo]["food"]["nf_total_carbohydrate"].floor();
    this.protein=data["hints"][hitNo]["food"]["nf_protein"].floor();
    this.servingSizeQty=data["hints"][hitNo]["food"]["nf_serving_size_qty"].floor();
    this.servingSizeUnit=data["hints"][hitNo]["food"]["nf_serving_size_unit"];
    printDetails();
  }

   // Food.fromAPIData(var data, int hitNo){
  //   this.name=data["hits"][hitNo]["item_name"];
  //   this.info=data["hits"][hitNo]["item_disc"];
  //   String cal = data["hits"][hitNo]["calories"]??'0';
  //   this.calories=int.tryParse(cal);
  //   this.fats=int.tryParse(data["hits"][hitNo]["nf_total_fat"]);
  //   this.carbohydrates=int.tryParse(data["hits"][hitNo]["nf_total_carbohydrate"]);
  //   this.protein=int.tryParse(data["hits"][hitNo]["nf_protein"]);
  //   this.servingSizeQty=int.tryParse(data["hits"][hitNo]["nf_serving_size_quantity"]);
  //   this.servingSizeUnit=data["hits"][hitNo]["nf_serving_size_unit"];
  //   printDetails();
  // }

  // Food.fromAPIData(var data, int hitNo){
  //   this.name=data["hits"][hitNo]["fields"]["item_name"];
  //   this.calories=data["hits"][hitNo]["fields"]["nf_calories"].floor();
  //   this.fats=data["hits"][hitNo]["fields"]["nf_total_fat"].floor();
  //   this.carbohydrates=data["hits"][hitNo]["fields"]["nf_total_carbohydrate"].floor();
  //   this.protein=data["hits"][hitNo]["fields"]["nf_protein"].floor();
  //   this.servingSizeQty=data["hits"][hitNo]["fields"]["nf_serving_size_qty"].floor();
  //   this.servingSizeUnit=data["hits"][hitNo]["fields"]["nf_serving_size_unit"];
  //   printDetails();
  // }

  void printDetails(){
    print('Name: $name, Calories: $calories, Fats: $fats, Carb: $carbohydrates,'
        'Protein: $protein, $servingSizeQty $servingSizeUnit ');
  }

  void printFullDetails(){
    print('$time/$date Name: $name, Calories: $calories, Fats: $fats, Carb: $carbohydrates, '
        'Protein: $protein, $servingSizeQty $servingSizeUnit, fullUrl: $fullUrl, '
        'Dim: $imageWidth x $imageHeight');
  }

}

class FoodListForm{
  List<Food> list = [];

  FoodListForm({this.list});

  FoodListForm.fromData(Map data){
    for(int i=0;i<10;i++){
      Food food = Food.fromAPIData(data, i);
      list.add(food);
    }
  }
}