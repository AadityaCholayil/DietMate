import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/food_image.dart';
import 'package:dietmate/form_pages/image_search_page.dart';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/conversion.dart';
import 'package:dietmate/shared/gradient.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:provider/provider.dart';

class FoodFormFinal extends StatefulWidget {
  final Food food;

  FoodFormFinal({this.food, Key key}):super(key:key);

  @override
  _FoodFormFinalState createState() => _FoodFormFinalState();
}

class _FoodFormFinalState extends State<FoodFormFinal> {
  Food _food;
  FoodImage _foodImage;
  String _name;
  int _calories, _fats, _protein, _carbohydrates;
  int _servingSizeQty;
  String _servingSizeUnit;
  String _fullUrl, _thumbnailUrl;
  int _imageWidth, _imageHeight;

  bool isLoading=false;
  String error='';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  InputDecoration inputDecoration(String label){
    return InputDecoration(
      // enabledBorder: OutlineInputBorder(
      //   borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
      // ),
      enabledBorder: GradientOutlineInputBorder(
        focusedGradient: customGradient2,
        unfocusedGradient: customGradient2,
        borderSide: BorderSide(width: 1, style: BorderStyle.solid, ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: GradientOutlineInputBorder(
        focusedGradient: customGradient,
        unfocusedGradient: customGradient2,
        borderSide: BorderSide(width: 2, style: BorderStyle.solid, ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Colors.purpleAccent[100], fontSize: 25,),
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.food.thumbnailUrl!=null){
      _fullUrl = widget.food.fullUrl;
      _thumbnailUrl =  widget.food.thumbnailUrl;
      _imageHeight =  widget.food.imageHeight;
      _imageWidth =  widget.food.imageWidth;
    }
    _name = widget.food.name;
    _calories = widget.food.calories;
    _fats = widget.food.fats;
    _protein = widget.food.protein;
    _carbohydrates = widget.food.carbohydrates;
    _servingSizeQty = widget.food.servingSizeQty;
    _servingSizeUnit = widget.food.servingSizeUnit;
  }

  Widget _buildName(){
    return TextFormField(
      initialValue: _name,
      decoration: inputDecoration('Food Name'),
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty ) {
          return 'It cannot be empty';
        }
        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildCalories(){
    return TextFormField(
      initialValue: _calories.toString(),
      decoration: inputDecoration('Calories'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int calories = int.tryParse(value);
        if (calories == null || calories < 0) {
          return 'Calories must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _calories = int.tryParse(value);
      },
    );
  }

  Widget _buildFats(){
    return TextFormField(
      initialValue: _fats.toString(),
      decoration: inputDecoration('Fats (g)'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int fats = int.tryParse(value);
        if (fats == null || fats < 0) {
          return 'Fats qty must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _fats = int.tryParse(value);
      },
    );
  }

  Widget _buildProtein(){
    return TextFormField(
      initialValue: _protein.toString(),
      decoration: inputDecoration('Protein (g)'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int protein = int.tryParse(value);
        if (protein == null || protein < 0) {
          return 'Protein qty must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _protein = int.tryParse(value);
      },
    );
  }

  Widget _buildCarbohydrates(){
    return TextFormField(
      initialValue: _carbohydrates.toString(),
      decoration: inputDecoration('Carbohydrates (g)'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int carbohydrates = int.tryParse(value);
        if (carbohydrates == null || carbohydrates < 0) {
          return 'Carbohydrates qty must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _carbohydrates = int.tryParse(value);
      },
    );
  }

  Widget _buildServingSizeQty(){
    return TextFormField(
      initialValue: _servingSizeQty.toString(),
      decoration: inputDecoration('Serving Size Qty'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int servingSizeQty = int.tryParse(value);
        if (servingSizeQty == null || servingSizeQty < 0) {
          return 'servingSizeQty must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _calories = int.tryParse(value);
      },
    );
  }

  Widget _buildServingSizeUnit(){
    return TextFormField(
      initialValue: _servingSizeUnit,
      decoration: inputDecoration('Serving Size Unit'),
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty ) {
          return 'Serving Size Unit cannot be empty';
        }
        return null;
      },
      onSaved: (String value) {
        _servingSizeUnit = value;
      },
    );
  }

  Widget _buildFoodImage(){
    return Column(
      children: <Widget>[
        Container(
          //MediaQuery.of(context).size.width/35
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          width: MediaQuery.of(context).size.width*0.44,
          height: MediaQuery.of(context).size.width*0.44,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(
            //   color: Theme.of(context).accentColor,
            // )
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                child: Image.network(
                  _fullUrl==null?'https://cdn.dribbble.com/users/1012997/screenshots/14073001/media/4994fedc83e967607f1e3b3e17525831.png?compress=1&resize=400x300'
                      : _fullUrl,
                  fit: _fullUrl==null?BoxFit.fitHeight:_imageWidth>_imageHeight?BoxFit.fitHeight:BoxFit.fitWidth,
                ),
                opacity: _fullUrl==null?0.6:1,
              ),
              _fullUrl==null?Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: MediaQuery.of(context).size.width*0.44,
                child: GradientButton(
                  extraPaddingHeight: 2.0,
                  extraPaddingWidth: 5.0,
                  label: Text(
                    'Select Image',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  onPressed: () async {
                    _foodImage = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => ImageSearch())
                    );
                    setState(() {
                      if(_foodImage!=null) {
                        _fullUrl = _foodImage.fullUrl;
                        _thumbnailUrl = _foodImage.thumbnailUrl;
                        _imageWidth = _foodImage.width;
                        _imageHeight = _foodImage.height;
                      }
                    });
                  },
                ),
              ):SizedBox.shrink(),
            ],
          ),
        ),
        _fullUrl!=null?Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          width: MediaQuery.of(context).size.width*0.44,
          child: GradientButton(
            expanded: true,
            label: Text(
              'Change Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300
              ),
            ),
            onPressed: () async {
              FoodImage foodImage = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ImageSearch())
              );
              setState(() {
                if(foodImage!=null){
                  _foodImage=foodImage;
                  _fullUrl=_foodImage.fullUrl;
                  _thumbnailUrl=_foodImage.thumbnailUrl;
                  _imageWidth=_foodImage.width;
                  _imageHeight=_foodImage.height;
                }
              });
            },
          ),
        ):SizedBox.shrink(),
      ],
    );
  }
  Widget _buildSubmitButton(BuildContext context2){
    final user = Provider.of<User>(context2);
    return Builder(builder: (context) => GradientButton(
      label: Text(
        'Submit',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
      ),
      extraPaddingWidth: 10.0,
      extraPaddingHeight: 2.0,
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return;
        }
        if(_thumbnailUrl==null){
          ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar('Select an Image!'));
          return;
        }
        setState(() => isLoading=true);
        DateTime now = DateTime.now();
        String _date = '${now.day}-${now.month}-${now.year}';
        String _week = weekNumber(now);
        _food=Food(
          date: _date,
          week: _week,
          name: _name,
          calories: _calories,
          fats: _fats,
          protein: _protein,
          carbohydrates: _carbohydrates,
          servingSizeQty: _servingSizeQty,
          servingSizeUnit: _servingSizeUnit,
          fullUrl: _fullUrl,
          thumbnailUrl: _thumbnailUrl,
          imageWidth: _imageWidth,
          imageHeight: _imageHeight,
        );
        _food.printFullDetails();
        dynamic result = await DatabaseService(uid: user.uid).addFood(_food);
        if (result=='error'){
          setState(() {
            error='error';
            isLoading=false;
          });
        }
        setState(() => isLoading=false);
        Navigator.popUntil(context2, ModalRoute.withName('/'));
      },
    ));
  }

  Widget _buildTitle(){
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(22, 0, 0, 13),
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


  SnackBar showCustomSnackBar(String message){
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Text(
        message,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: Theme.of(context).accentColor,
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            fit: StackFit.loose,
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
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: customGradient,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(13),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTitle(),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          //color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 15),
                          child: Column(
                            children: [
                              _buildName(),
                              SizedBox(height: 10),
                              _buildCalories(),
                              SizedBox(height: 10),
                              Padding(
                                padding: _thumbnailUrl==null?EdgeInsets.zero:EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _buildFoodImage(),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.42,
                                          child: _buildFats(),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.42,
                                          child: _buildProtein(),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.42,
                                          child: _buildCarbohydrates(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.43,
                                    child: _buildServingSizeQty(),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.43,
                                    child: _buildServingSizeUnit(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      !isLoading?_buildSubmitButton(context)
                          :LoadingSmall(),
                      SizedBox(height: 10),
                      error!=''?Text(
                        'Something Went Wrong, Please Try Again',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                        ),
                      ):SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
