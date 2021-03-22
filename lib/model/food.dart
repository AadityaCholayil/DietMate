class Food{
  String name;
  String calories;
  String fats;
  String carbohydrates;
  String protein;
  String servingSizeQty;
  String servingSizeUnit;

  Food({this.name, this.calories, this.fats, this.carbohydrates, this.protein,
    this.servingSizeQty, this.servingSizeUnit});

  Food.fromData(var data, int hitNo){
    this.name=data["hits"][hitNo]["fields"]["item_name"];
    this.calories=data["hits"][hitNo]["fields"]["nf_calories"].toString();
    this.fats=data["hits"][hitNo]["fields"]["nf_total_fat"].toString();
    this.carbohydrates=data["hits"][hitNo]["fields"]["nf_total_carbohydrate"].toString();
    this.protein=data["hits"][hitNo]["fields"]["nf_protein"].toString();
    this.servingSizeQty=data["hits"][hitNo]["fields"]["nf_serving_size_qty"].toString();
    this.servingSizeUnit=data["hits"][hitNo]["fields"]["nf_serving_size_unit"];
    printDetails();
  }

  void printDetails(){
    print('name: $name, calories: $calories, fats: $fats, carb: $carbohydrates,'
        'protein: $protein, $servingSizeQty $servingSizeUnit ');
  }

}