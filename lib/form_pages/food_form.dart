import 'package:animations/animations.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/form_pages/food_form_final.dart';
import 'package:dietmate/shared/loading.dart';
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
  FoodListForm foodList;
  double screenHeight, screenWidth;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getData(String query) async {
    Client _client = Client();
    Response response = await _client
        .get(Uri.https("nutritionix-api.p.rapidapi.com", "/v1_1/search/$query",
        {"fields": "item_name,item_id,brand_name,nf_calories,nf_total_fat,nf_total_carbohydrate,nf_protein",
          "limit": "5"}),
        headers: {
          "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
          "x-rapidapi-host": "nutritionix-api.p.rapidapi.com",
        }
    );
    // Response response = await get("https://nutritionix-api.p.rapidapi.com/v1_1/search/$foodName?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat%2Cnf_total_carbohydrate%2Cnf_protein",
    //     headers: {
    //       "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
    //       "x-rapidapi-host": "nutritionix-api.p.rapidapi.com"
    //     }
    // );
    Map data = jsonDecode(response.body);
    print(data);
    print(data['hits'].length);
    if(data['max_score']!=null && data['max_score']>2)
      return data;
    else
      return 'No results';
  }

  Widget _buildName(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Food Name',
        labelStyle: TextStyle(fontSize: 25),
      ),
      textCapitalization: TextCapitalization.words,
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

  Widget customFoodButton(){
    return TextButton(
      child: Text(
        'Create a Custom One.',
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).accentColor,
          decoration: TextDecoration.underline,
        ),
      ),
      onPressed: (){
        Food food;
        food = Food(
          name: foodName,
          calories: 0,
          fats: 0,
          protein: 0,
          carbohydrates: 0,
          servingSizeQty: 1,
          servingSizeUnit: 'serving',
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: '/FoodForm'),
              builder: (BuildContext context) => FoodFormFinal(food: food,)
            )
        );
      },
    );
  }

  Widget _buildList(FoodListForm foodList){
    if(foodList.list.length==0){
      return Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No results found.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              customFoodButton(),
            ],
          ),
          SizedBox(height: 18),
        ],
      );
    }
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Select One:',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          //Divider(thickness: 2),
          ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              Food food=foodList.list[index];
              return OpenContainer(
                closedColor: Theme.of(context).canvasColor,
                openColor: Theme.of(context).canvasColor,
                transitionDuration: Duration(milliseconds: 500),
                closedBuilder: (context, openBuilder){
                  return InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        color: Colors.transparent,
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
                    onTap: (){
                      openBuilder();
                    },
                  );
                },
                openBuilder: (context, closedBuilder){
                  return FoodFormFinal(food: food);
                },
              );
            },
            itemCount: foodList.list.length,
            separatorBuilder: (BuildContext context, int index) => Divider(thickness: 2),
          ),
          Divider(thickness: 2),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not in the List?',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              customFoodButton(),
            ],
          ),
          SizedBox(height: 6,)
        ],
      ),
    );
  }

  Widget _buildSearchButton(){
    return Builder(builder: (context) => ElevatedButton(
      child: Text(
        'Search',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
      ),
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return;
        }
        setState(() {
          isSearching=true;
          searchDone=false;
          _formKey.currentState.save();
        });
        foodData = await getData(foodName);
        if(foodData=='No results'){
          foodList=FoodListForm(list: []);
        }else{
          foodList=FoodListForm.fromData(foodData);
        }
        setState(() {
          isSearching=false;
          searchDone=true;
        });
      },
    ));
  }

  Widget _buildTitle(){
    double paddingHeight=0;
    if(searchDone==true){
      switch (foodList.list.length) {
        case 0:
          paddingHeight = screenHeight/3.3;
          break;
        case 1:
          paddingHeight = screenHeight/4.2;
          break;
        case 2:
          paddingHeight = screenHeight/4.9;
          break;
        case 3:
          paddingHeight = screenHeight/7.2;
          break;
        case 4:
          paddingHeight = screenHeight/12;
          break;
        case 5:
          paddingHeight = screenHeight/25;
          break;
      }
    }
    return Center(
      child: Container(
        padding: searchDone==true?EdgeInsets.fromLTRB(22, paddingHeight, 0, 5)
            :EdgeInsets.fromLTRB(22, screenHeight/3.5, 0, 30),
        alignment: Alignment.centerLeft,
        child: Text(
          'Enter Food',
          style: TextStyle(
              fontSize: 55,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight=MediaQuery.of(context).size.height;
    screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildTitle(),
                _buildName(),
                SizedBox(height: 10,),
                isSearching==true?Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: 50,
                      child: LoadingSmall(),
                    ),
                    SizedBox(height: 30),
                  ],
                ):SizedBox.shrink(),
                searchDone==true?_buildList(foodList):SizedBox.shrink(),
                _buildSearchButton(),
                searchDone!=true?SizedBox(height:screenHeight/9,):
                    SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
