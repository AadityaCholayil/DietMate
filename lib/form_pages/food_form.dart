import 'package:animations/animations.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/form_pages/food_form_final.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class FoodForm extends StatefulWidget {
  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {

  String foodName='';
  var foodData;
  bool isSearching=false;
  bool searchDone=false;
  bool noResults=false;
  FoodListForm foodList;
  double screenHeight, screenWidth;
  double searchHeight;

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
    // Response response = await _client
    //     .post(Uri.https("trackapi.nutritionix.com", "/v2/natural/nutrients",
    //     {
    //       "fields": "item_name,item_id,brand_name,nf_calories,nf_total_fat,nf_total_carbohydrate,nf_protein",
    //       "limit": "5"
    //     }),
    //     body: {
    //       "query" : query,
    //     },
    //     headers: {
    //       "x-app-id": "df24937b",
    //       "x-app-key": "cd83b97fdf4bd32131ddc36e97e0bf12",
    //       "x-remote-user-id": "0",
    //     }
    // );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 13, bottom: 5),
          child: Text(
            'Food Name',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).unselectedWidgetColor,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 18, 15, 18),
            filled: true,
            //fillColor: Color(0xFFE3E7EF),
            fillColor: Theme.of(context).buttonColor,
            suffixIcon: Icon(Icons.search, size: 28),
            labelText: 'Eg. Dosa',
            labelStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8C8C8C)
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never
          ),
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
          validator: (String value) {
            if (value.isEmpty ) {
              return 'Food name is empty!';
            }
            return null;
          },
          onSaved: (String value) {
            foodName = value;
          },
        ),
      ],
    );
  }

  Widget customFoodButton(){
    return TextButton(
      style: TextButton.styleFrom(
        primary: Color(0xFF2ACD07)
      ),
      child: Text(
        'Create a custom one',
        style: TextStyle(
          fontSize: 26,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
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
          SizedBox(height: 14),
        ],
      );
    }
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 1),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height*0.55,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 5,),
              ListView.separated(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                  Food food=foodList.list[index];
                  return OpenContainer(
                    closedElevation: 0,
                    closedColor: Theme.of(context).cardColor,
                    openColor: Theme.of(context).canvasColor,
                    transitionDuration: Duration(milliseconds: 500),
                    closedBuilder: (context, openBuilder){
                      return InkWell(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            color: Theme.of(context).cardColor,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${food.name}',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w300
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  'Calories: ${food.calories} KCal',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w300
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
                      return FoodFormFinal(food: food, query: foodName);
                    },
                  );
                },
                itemCount: foodList.list.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(thickness: 1, color: Theme.of(context).primaryColor,),
              ),
              SizedBox(height: 10,)
              //Divider(thickness: 1, color: Theme.of(context).primaryColor,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
        primary: Color(0xFF2ACD07),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        )
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Text(
        'Search',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
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
    );
  }

  Widget _buildTitle(){
    return Center(
      child: Container(
        padding: searchDone?EdgeInsets.fromLTRB(22, 5, 0, 10)
            :EdgeInsets.fromLTRB(22, 0, 0, 30),
        alignment: Alignment.center,
        child: Text(
          'Search',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: Color( 0xFF2ACD07)
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/search_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20),
        height: screenHeight,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(),
              _buildName(),
              SizedBox(height: 15,),
              isSearching?Column(
                children: [
                  SizedBox(height: 33),
                  LoadingSmall(color: Color(0xFF2ACD07)),
                  SizedBox(height: 22),
                ],
              ):SizedBox.shrink(),
              searchDone?
              _buildList(foodList)
                  :SizedBox.shrink(),
              SizedBox(height: 36),
              _buildSearchButton(),
              SizedBox(height: searchDone?1:32),
              noResults?SizedBox.shrink():
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'or ',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  customFoodButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
