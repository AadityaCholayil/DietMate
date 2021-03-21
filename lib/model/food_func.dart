import 'food.dart';

Food fillDetails(var data, int hitNo){
  Food food=Food(
    name: data["hits"][hitNo]["fields"]["item_name"],
    calories: data["hits"][hitNo]["fields"]["nf_calories"],
    fats: data["hits"][hitNo]["fields"]["nf_total_fat"],
    carbohydrates: data["hits"][hitNo]["fields"]["nf_total_carbohydrate"],
    protein: data["hits"][hitNo]["fields"]["nf_protein"],
    servingSizeQty: data["hits"][hitNo]["fields"]["nf_serving_size_qty"],
    servingSizeUnit:data["hits"][hitNo]["fields"]["nf_serving_size_unit"],
  );
  food.printDetails();
  return food;
}