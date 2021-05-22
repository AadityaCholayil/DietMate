import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:provider/provider.dart';

class FoodFormFinal extends StatefulWidget {
  final Food food;
  final String query;
  FoodFormFinal({this.food, this.query, Key key}):super(key:key);

  @override
  _FoodFormFinalState createState() => _FoodFormFinalState();
}

class _FoodFormFinalState extends State<FoodFormFinal> {
  String _uid;
  Food _food;
  FoodImage _foodImage;
  String _name;
  String _time = '1000';
  int _calories, _fats, _protein, _carbohydrates;
  int _servingSizeQty;
  String _servingSizeUnit;
  String _fullUrl, _thumbnailUrl;
  int _imageWidth, _imageHeight;
  Timestamp _timestamp;

  DateTime pickedTime;

  bool isLoading=false;
  String error='';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.food.uid!=null){
      _uid=widget.food.uid;
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
    if (widget.food.uid==null) {
      DateTime now = DateTime.now();
      pickedTime=DateTime(now.year, now.month, now.day, now.hour, now.minute);
      _timestamp=Timestamp.fromDate(pickedTime);
      _time=convertTo12Hr(pickedTime);
    } else {
      pickedTime = widget.food.timestamp.toDate();
      _timestamp = widget.food.timestamp;
      _time = convertTo12Hr(pickedTime);
    }
  }

  InputDecoration _inputDecoration(String label){
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20, 18, 15, 18),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      labelText: label,
      labelStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8C8C8C)
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never
    );
  }

  TextStyle _style = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400);

  Widget _buildName(){
    return TextFormField(
      initialValue: _name,
      decoration: _inputDecoration('Food Name'),
      keyboardType: TextInputType.name,
      style: _style,
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
      decoration: _inputDecoration('Calories'),
      keyboardType: TextInputType.number,
      style: _style,
      validator: (String value) {
        int calories = int.tryParse(value);
        if (calories == null || calories < 0) {
          return 'Calories must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        print(value);
        _calories = double.tryParse(value).floor();
      },
    );
  }

  Widget _buildFats(){
    return TextFormField(
      initialValue: _fats.toString(),
      decoration: _inputDecoration('Fats (g)'),
      keyboardType: TextInputType.number,
      style: _style,
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
      decoration: _inputDecoration('Protein (g)'),
      keyboardType: TextInputType.number,
      style: _style,
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
      decoration: _inputDecoration('Carbohydrates (g)'),
      keyboardType: TextInputType.number,
      style: _style,
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
      decoration: _inputDecoration('Serving Size Qty'),
      keyboardType: TextInputType.number,
      style: _style,
      validator: (String value) {
        int servingSizeQty = int.tryParse(value);
        if (servingSizeQty == null || servingSizeQty < 0) {
          return 'servingSizeQty must be greater than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _servingSizeQty = int.tryParse(value);
      },
    );
  }

  Widget _buildServingSizeUnit(){
    return TextFormField(
      initialValue: _servingSizeUnit,
      decoration: _inputDecoration('Serving Size Unit'),
      keyboardType: TextInputType.name,
      style: _style,
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
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: MediaQuery.of(context).size.width*0.46,
      height: MediaQuery.of(context).size.width*0.46,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(17),
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
            opacity: 1,
          ),
          _fullUrl==null?Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            //width: MediaQuery.of(context).size.width*0.44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  primary: Color(0xFF2ACD07),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  )
              ),
              child: Text(
                'Select Image',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
              ),
              onPressed: () async {
                _foodImage = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => ImageSearch(query: widget.query))
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
    );
  }

  // _fullUrl!=null?Container(
  //   alignment: Alignment.center,
  //   margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //   width: MediaQuery.of(context).size.width*0.44,
  //   child: GradientButton(
  //     expanded: true,
  //     label: Text(
  //       'Change Image',
  //       style: TextStyle(
  //         fontSize: 20,
  //         fontWeight: FontWeight.w300,
  //         color: Colors.white,
  //       ),
  //     ),
  //     onPressed: () async {
  //       FoodImage foodImage = await Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (BuildContext context) => ImageSearch())
  //       );
  //       setState(() {
  //         if(foodImage!=null){
  //           _foodImage=foodImage;
  //           _fullUrl=_foodImage.fullUrl;
  //           _thumbnailUrl=_foodImage.thumbnailUrl;
  //           _imageWidth=_foodImage.width;
  //           _imageHeight=_foodImage.height;
  //         }
  //       });
  //     },
  //   ),
  // ):SizedBox.shrink(),

  Widget _buildTime(Size size){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: MediaQuery.of(context).size.width*0.44,
        width: MediaQuery.of(context).size.width*0.370,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.zero,
              child: Text(
                convertTo12Hr(pickedTime??DateTime.now()).substring(0,5),
                style: TextStyle(
                  fontSize: 51,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              convertTo12Hr(pickedTime??DateTime.now()).substring(6,8),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 13, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: size.width*0.081),
                    primary: Color(0xFF2ACD07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
                child: Text(
                  'Time',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
                onPressed: () async {
                  TimeOfDay time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time!=null) {
                    setState(() {
                      if (widget.food.uid==null) {
                        DateTime now = DateTime.now();
                        pickedTime=DateTime(now.year, now.month, now.day, time.hour, time.minute);
                      } else {
                        pickedTime=DateTime(pickedTime.year, pickedTime.month, pickedTime.day, time.hour, time.minute);
                      }
                      _timestamp=Timestamp.fromDate(pickedTime);
                      _time=convertTo12Hr(pickedTime);
                      print(_time);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context2){
    final user = Provider.of<User>(context2);
    String type = widget.food.uid==null?'Submit':'Update';
    return GradientButton(
      label: Text(
        type,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Colors.white
        ),
      ),
      extraPaddingWidth: 10.0,
      extraPaddingHeight: 2.0,
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return;
        }
        setState(() {
          _formKey.currentState.save();
        });
        if(_thumbnailUrl==null){
          ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar('Select an Image!'));
          return;
        }
        // if(_timestamp==null){
        //   ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar('Select time!'));
        //   return;
        // }
        setState(() => isLoading=true);
        String _date;
        if (widget.food.uid==null) {
          DateTime now = DateTime.now();
          _date = dateToString(now);
        } else {
          _date = dateToString(widget.food.timestamp.toDate());
        }
        _food=Food(
          date: _date,
          time: _time,
          timestamp: _timestamp,
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
        dynamic result;
        if (widget.food.uid==null) {
          result = await DatabaseService(uid: user.uid).addFood(_food);
        } else {
          _food.uid=_uid;
          result = await DatabaseService(uid: user.uid).updateFood(_food);
        }
        if (result=='error'){
          setState(() {
            error='error';
            isLoading=false;
          });
        }
        setState(() => isLoading=false);
        Navigator.popUntil(context2, ModalRoute.withName('/'));
      },
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

  Widget _buildTextHelp(String text){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 13, bottom: 5, top: 5),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).unselectedWidgetColor,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  Widget _buildRow(Size size, String label1, Widget widget1, String label2, Widget widget2){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: size.width*0.425,
          child: Column(
            children: <Widget>[
              _buildTextHelp(label1),
              widget1,
            ],
          ),
        ),
        Container(
          width: size.width*0.425,
          child: Column(
            children: <Widget>[
              _buildTextHelp(label2),
              widget2,
            ],
          ),
        ),
      ],
    );
  }

  Text errorText(BuildContext context){
    return Text(
      'Something Went Wrong, Please Try Again',
      style: TextStyle(
          color: Theme.of(context).errorColor,
          fontSize: 20,
          fontWeight: FontWeight.w300
      ),
    );
  }

  Widget _buildTitle(){
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        alignment: Alignment.bottomCenter,
        child: Text(
          'Food Details',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Color( 0xFF2ACD07),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0),
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 1),
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/search_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        height: size.height,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(size.width*0.057),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitle(),
                  _buildTextHelp('Food Name'),
                  _buildName(),
                  _buildRow(size, 'Calories', _buildCalories(), 'Fats', _buildFats()),
                  SizedBox(height: 17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildFoodImage(),
                      _buildTime(size),
                    ],
                  ),
                  _buildRow(size, 'Protein', _buildProtein(), 'Carbohydrates', _buildCarbohydrates()),
                  _buildRow(size, 'Serving Size Qty', _buildServingSizeQty(), 'Serving Size Unit', _buildServingSizeUnit()),
                  SizedBox(height: 15),
                  !isLoading?_buildSubmitButton(context)
                      :LoadingSmall(color: Color( 0xFF2ACD07)),
                  SizedBox(height: 10),
                  error!=''?errorText(context):SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
