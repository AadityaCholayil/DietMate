import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_list_day.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

ListView buildListView(FoodListDay foodList, BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: foodList.list.length,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int i){
      Food food = foodList.list[i];
      return buildCard(food, context);
    },
  );
}

InkWell buildCard(Food food, BuildContext context) {
  return InkWell(
    onTap: () {
      showDialog(context: context, builder: (BuildContext context) => foodInfoDialog(food, context));
    },
    child: GlassContainer(
      borderRadius: BorderRadius.all(Radius.circular(34.0)),
      color: Theme.of(context).cardColor.withOpacity(0.55),
      borderColor: Theme.of(context).colorScheme.surface.withOpacity(0.0),
      height:107,
      width: MediaQuery.of(context).size.width,
      //isFrostedGlass: true,
      //frostedOpacity: 0.05,
      blur: 5,
      margin: EdgeInsets.only(bottom: 13),
      child:Container(
        padding: EdgeInsets.all(6),
        height: 107,
        //color: Colors.white10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left:16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${food.name.length>20?food.name.substring(0,18)+"..":food.name}',
                    style: TextStyle(
                        fontSize:26,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  //SizedBox(height: 1),
                  Text(
                    'Calories: ${food.calories} Kcal',
                    style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  //SizedBox(height: 1),
                  Text(
                    'Time: ${food.time}',
                    style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34)
              ),
              height: 95,
              width: 95,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                food.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget foodInfoDialog(Food food, BuildContext context){
  return Dialog(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    insetPadding: EdgeInsets.zero,
    child: Container(
      height: 630,
      width: MediaQuery.of(context).size.width*0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width*0.9,
            child: Image.network(
              food.fullUrl,
              fit: food.imageWidth>food.imageHeight? BoxFit.fitHeight : BoxFit.fitWidth,
            ),
          ),
          SizedBox(height:5),
          Container(
            padding: EdgeInsets.only(left:12,top: 5),
            width: 400,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start ,
              children: <Widget>[
                Text(
                  '${food.name}',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height:1),
                Text(
                  'Calories: ${food.calories} Kcal',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height:1),
                Text(
                  'Time: ${food.time}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height:1),
                Text(
                  'Protein: ${food.protein}g',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height:1),
                Text(
                  'Fats: ${food.fats}g',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height:1),
                Text(
                  'Carbohydrates: ${food.carbohydrates} Kcal',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(bottom: 5,right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize:23,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    onPressed: () {
                      print('Pressed');
                    }

                ),
                TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontSize:23,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    onPressed: () {
                      print('Pressed');
                    }
                ),
                TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize:23,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      print('Pressed');
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
