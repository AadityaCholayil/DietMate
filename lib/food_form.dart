import 'package:dietmate/model/food.dart';
import 'package:dietmate/pages/image_search_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class FoodForm extends StatefulWidget {
  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {

  String foodName='default';
  Food food1 = new Food();
  Food food2 = new Food();
  Food food3 = new Food();
  Food food4 = new Food();
  Food food5 = new Food();
  var foodData;
  bool isSearching=false;
  bool searchDone=false;
  List<Food> foodList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<Map> getData() async {
    Response response = await get("https://nutritionix-api.p.rapidapi.com/v1_1/search/$foodName?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat%2Cnf_total_carbohydrate%2Cnf_protein",
        headers: {
          "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
          "x-rapidapi-host": "nutritionix-api.p.rapidapi.com"
        }
    );
    Map data = jsonDecode(response.body);
    return data;
  }

  Widget _buildName(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'FoodName',
          labelStyle: TextStyle(fontSize: 25)
      ),
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty ) {
          return 'It cannot be empty';
        }
        return null;
      },
      onSaved: (String value) {
        foodName = value;
      },
    );
  }

  Widget _buildList(List<Food> foodList){
    return Container(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        //primary: false,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index){
          Food food=foodList[index];
          return InkWell(
            child: Container(
              //color: Colors.yellow,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${food.name}',
                    style: TextStyle(
                      fontSize: 25
                    ),
                  ),
                  Text(
                    'Calories: ${food.calories} Kcal',
                    style: TextStyle(
                        fontSize: 19
                    ),
                  ),
                ],
              )
            ),
            onTap: (){

            },
          );
        },
        itemCount: foodList.length,
        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              SizedBox(height: 10,),
              isSearching==true?Column(
                children: [
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                ],
              ):SizedBox.shrink(),
              searchDone==true?_buildList(foodList):SizedBox.shrink(),
              Builder(builder: (context) => ElevatedButton(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
                onPressed: () async {
                  setState(() {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    isSearching=true;
                    _formKey.currentState.save();
                  });
                  foodData = await getData();
                  food1.set(foodData, 0);
                  food2.set(foodData, 1);
                  food3.set(foodData, 2);
                  foodList.add(food1);
                  foodList.add(food2);
                  foodList.add(food3);
                  // food4.set(foodData, 3);
                  // food5.set(foodData, 4);
                  setState(() {
                    isSearching=false;
                    searchDone=true;
                  });
                },
              )),
              ElevatedButton(
                child: Text('Search Image'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => ImageSearch())
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
