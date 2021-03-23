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
  var foodData;
  bool isSearching=false;
  bool searchDone=false;
  FoodList foodList;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<dynamic> getData() async {
    Response response = await get("https://nutritionix-api.p.rapidapi.com/v1_1/search/$foodName?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat%2Cnf_total_carbohydrate%2Cnf_protein",
        headers: {
          "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
          "x-rapidapi-host": "nutritionix-api.p.rapidapi.com"
        }
    );
    Map data = jsonDecode(response.body);
    print(data);
    if(data['max_score']!=null && data['max_score']>2)
      return data;
    else
      return 'No results';
  }

  Widget _buildName(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Food Name',
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

  Widget _buildList(FoodList foodList){
    if(foodList.list.length==0){
      return Text('No results found');
    }
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            //primary: false,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              Food food=foodList.list[index];
              return InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  //color: Colors.yellow,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${food.name}',
                        style: TextStyle(
                          fontSize: 25,
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
                onTap: (){},
              );
            },
            itemCount: foodList.list.length,
            separatorBuilder: (BuildContext context, int index) => Divider(thickness: 2),
          ),
          Divider(thickness: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    searchDone=false;
                    _formKey.currentState.save();
                  });
                  foodData = await getData();
                  if(foodData=='No results'){
                    foodList=FoodList(list: []);
                  }else{
                    foodList=FoodList.fromData(foodData);
                  }
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
