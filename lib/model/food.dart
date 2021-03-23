class Food{
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

  Food({this.name, this.calories, this.fats, this.carbohydrates, this.protein,
    this.servingSizeQty, this.servingSizeUnit, this.fullUrl, this.thumbnailUrl,
    this.imageWidth, this.imageHeight});

  Food.fromData(var data, int hitNo){
    this.name=data["hits"][hitNo]["fields"]["item_name"];
    this.calories=data["hits"][hitNo]["fields"]["nf_calories"].floor();
    this.fats=data["hits"][hitNo]["fields"]["nf_total_fat"].floor();
    this.carbohydrates=data["hits"][hitNo]["fields"]["nf_total_carbohydrate"].floor();
    this.protein=data["hits"][hitNo]["fields"]["nf_protein"].floor();
    this.servingSizeQty=data["hits"][hitNo]["fields"]["nf_serving_size_qty"].floor();
    this.servingSizeUnit=data["hits"][hitNo]["fields"]["nf_serving_size_unit"];
    printDetails();
  }

  void printDetails(){
    print('name: $name, calories: $calories, fats: $fats, carb: $carbohydrates,'
        'protein: $protein, $servingSizeQty $servingSizeUnit ');
  }

}

class FoodList{
  List<Food> list = [];

  FoodList({this.list});

  FoodList.fromData(Map data){
    for(int i=0;i<5;i++){
      Food food = Food.fromData(data, i);
      if(data["hits"][i]["_score"]>2){
        list.add(food);
      }
    }
  }
}