import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/image_details.dart';
import 'package:dietmate/pages/image_search_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    if(widget.food.fullUrl==null){
      _name = widget.food.name;
      _calories = widget.food.calories;
      _fats = widget.food.fats;
      _protein = widget.food.protein;
      _carbohydrates = widget.food.carbohydrates;
      _servingSizeQty = widget.food.servingSizeQty;
      _servingSizeUnit = widget.food.servingSizeUnit;
    }
  }

  Widget _buildName(){
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
        labelText: 'Food Name',
        labelStyle: TextStyle(fontSize: 25),
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
        _name = value;
      },
    );
  }

  Widget _buildCalories(){
    return TextFormField(
      initialValue: _calories.toString(),
      decoration: InputDecoration(
        labelText: 'Calories',
        labelStyle: TextStyle(fontSize: 25),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int calories = int.tryParse(value);
        if (calories == null || calories <= 0) {
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
      decoration: InputDecoration(
        labelText: 'Fats (g)',
        labelStyle: TextStyle(fontSize: 25),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int fats = int.tryParse(value);
        if (fats == null || fats <= 0) {
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
      decoration: InputDecoration(
        labelText: 'Protein (g)',
        labelStyle: TextStyle(fontSize: 25),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int protein = int.tryParse(value);
        if (protein == null || protein <= 0) {
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
      decoration: InputDecoration(
        labelText: 'Carbohydrates (g)',
        labelStyle: TextStyle(fontSize: 25),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int carbohydrates = int.tryParse(value);
        if (carbohydrates == null || carbohydrates <= 0) {
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
      decoration: InputDecoration(
        labelText: 'Serving Size Qty',
        labelStyle: TextStyle(fontSize: 25),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        int servingSizeQty = int.tryParse(value);
        if (servingSizeQty == null || servingSizeQty <= 0) {
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
      decoration: InputDecoration(
        labelText: 'Serving Size Unit',
        labelStyle: TextStyle(fontSize: 25),
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
        _servingSizeUnit = value;
      },
    );
  }

  Widget _buildFoodImage(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
          width: MediaQuery.of(context).size.width*0.44,
          height: MediaQuery.of(context).size.width*0.44,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)
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
                child: ElevatedButton(
                  child: Text(
                    'Select Image',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  onPressed: () async {
                    setState(() async{
                      _foodImage = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => ImageSearch())
                      );
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
          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
          width: MediaQuery.of(context).size.width*0.44,
          child: ElevatedButton(
            child: Text(
              'Select Image',
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            onPressed: () async {
              _foodImage = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ImageSearch())
              );
              _fullUrl=_foodImage.fullUrl;
              _thumbnailUrl=_foodImage.thumbnailUrl;
              _imageWidth=_foodImage.width;
              _imageHeight=_foodImage.height;
            },
          ),
        ):SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTitle(){
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(22, 0, 0, 13),
        alignment: Alignment.centerLeft,
        child: Text(
          'Food Form',
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTitle(),
            _buildName(),
            SizedBox(height: 10),
            _buildCalories(),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                _buildFoodImage(),
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.45,
                      child: _buildFats(),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width*0.45,
                      child: _buildProtein(),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width*0.45,
                      child: _buildCarbohydrates(),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: _buildServingSizeQty(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: _buildServingSizeUnit(),
                ),
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: Text(
                'Submit',
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              onPressed: (){
                _food=Food(
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
                _food.printDetails();
              },
            )
          ],
        ),
      ),
    );
  }
}
