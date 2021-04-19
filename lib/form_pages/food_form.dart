import 'package:animations/animations.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/form_pages/food_form_final.dart';
import 'package:dietmate/shared/gradient.dart';
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

  String foodName='default';
  var foodData;
  bool isSearching=false;
  bool searchDone=false;
  bool noResults=false;
  FoodListForm foodList;
  double screenHeight, screenWidth;
  double searchHeight;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _searchKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(updateLayout);
    super.initState();
  }

  updateLayout(_) {
    _getPositions();
  }

  Offset _getPositions() {
    final RenderBox renderBoxSearch = _searchKey.currentContext.findRenderObject();
    final positionSearch = renderBoxSearch.localToGlobal(Offset.zero);
    print("Position of Search: $positionSearch ");
    return positionSearch;
  }

  void updateHeight(){
    searchHeight=_getPositions().dy/2;
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
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   width: 2,
        //   color: Theme.of(context).disabledColor
        // ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        key: _searchKey,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          suffixIcon: Icon(Icons.search, size: 28),
          labelText: 'Food Name',
          labelStyle: TextStyle(fontSize: 25),
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
    );
  }

  Widget customFoodButton(){
    return TextButton(
      child: GradientText(
        'Create a custom one',
        size: 23.0,
        underline: true,
        fontWeight: FontWeight.w400,
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
        // side: BorderSide(
        //   width: 2,
        //   color: Theme.of(context).disabledColor
        // ),
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
                      return FoodFormFinal(food: food);
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
    return GradientButton(
      label: Text(
        'Search',
        style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w300,
            color: Colors.white,
        ),
      ),
      extraPaddingHeight: 2.0,
      extraPaddingWidth: 2.0,
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return;
        }
        setState(() {
          isSearching=true;
          searchDone=false;
          noResults=false;
          _formKey.currentState.save();
          updateHeight();
        });
        foodData = await getData(foodName);
        if(foodData=='No results'){
          foodList=FoodListForm(list: []);
          noResults=true;
        }else{
          foodList=FoodListForm.fromData(foodData);
        }
        setState(() {
          isSearching=false;
          searchDone=true;
          updateHeight();
        });
      },
    );
    // return Builder(builder: (context) => Container(
    //   decoration: BoxDecoration(
    //       gradient: customGradient
    //   ),
    //   child: ElevatedButton(
    //     style: ButtonStyle(),
    //     clipBehavior: Clip.antiAliasWithSaveLayer,
    //     child: Text(
    //       'Search',
    //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
    //     ),
    //     onPressed: () async {
    //       if (!_formKey.currentState.validate()) {
    //         return;
    //       }
    //       setState(() {
    //         isSearching=true;
    //         searchDone=false;
    //         _formKey.currentState.save();
    //       });
    //       foodData = await getData(foodName);
    //       if(foodData=='No results'){
    //         foodList=FoodListForm(list: []);
    //       }else{
    //         foodList=FoodListForm.fromData(foodData);
    //       }
    //       setState(() {
    //         isSearching=false;
    //         searchDone=true;
    //       });
    //     },
    //   ),
    // ));
  }

  Widget _buildTitle(){
    return Center(
      child: Container(
        padding: searchDone?EdgeInsets.fromLTRB(22, 5, 0, 10)
            :EdgeInsets.fromLTRB(22, 0, 0, 30),
        alignment: Alignment.centerLeft,
        child: Text(
          'Search Food',
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.bold,
            color: Colors.white
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
      body: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius:  BorderRadius.vertical(bottom: Radius.elliptical(130, 40)),
            ),
            elevation: 8,
            child: Container(
              //height: searchHeight,
              height: noResults?395:searchDone?180:isSearching?326:407,
              decoration: BoxDecoration(
                gradient: customGradient,
              ),
            ),
          ),
          Container(
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
                      SizedBox(height: 30),
                      LoadingSmall(),
                      SizedBox(height: 30),
                    ],
                  ):SizedBox.shrink(),
                  searchDone?
                  _buildList(foodList)
                      :SizedBox.shrink(),
                  SizedBox(height: 17),
                  _buildSearchButton(),
                  SizedBox(height: searchDone?1:15),
                  noResults?SizedBox.shrink():
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'or ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      customFoodButton(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
