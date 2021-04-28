import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  @override
  _AdditionalDetailsScreenState createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {

  String _name;
  int _age;
  bool _isMale = true;
  String _gender;
  int _height;
  int _weight;
  double _activityLevel = 1.5;
  String _activity = 'Sedentary: little or no exercise';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Widget _buildName(){
    return TextFormField(
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
          labelText: 'Name',
          labelStyle: TextStyle(fontSize: 25),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildAge(){
    return TextFormField(
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
          labelText: 'Age',
          labelStyle: TextStyle(fontSize: 25),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value)<0) {
          return 'Age cannot be less than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _age= int.tryParse(value);
      },
    );
  }

  Widget _buildGender(){
    return Row(
      children: [
        SizedBox(width: 10,),
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        ),
        Spacer(),
        Radio(
          value: true,
          groupValue: _isMale,
          onChanged: (val){
            setState(() {
              _isMale=val;
              print(val);
            });
          },
        ),
        Text(
          'Male',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w300,
          ),
        ),
        Radio(
          value: false,
          groupValue: _isMale,
          onChanged: (val){
            setState(() {
              _isMale=val;
              print(val);
            });
          },
        ),
        Text(
          'Female',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildHeight(){
    return TextFormField(
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
          labelText: 'Height',
          labelStyle: TextStyle(fontSize: 25),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value)<0) {
          return 'Height cannot be less than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _height = int.tryParse(value);
      },
    );
  }

  Widget _buildWeight(){
    return TextFormField(
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
          labelText: 'Weight',
          labelStyle: TextStyle(fontSize: 25),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value)<0) {
          return 'Weight cannot be less than 0';
        }
        return null;
      },
      onSaved: (String value) {
        _weight= int.tryParse(value);
      },
    );
  }

  Widget _buildActivity(){
    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        // width: MediaQuery.of(context).size.width-20,
        child: DropdownButton<String>(
          value: _activity,
          icon: Icon(Icons.arrow_drop_down),
          dropdownColor: Theme.of(context).backgroundColor,
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          underline: Container(
            height: 3,
            //color: HexColor(color3),
          ),
          onChanged: (String newValue) {
            setState(() {
              _activity = newValue;
            });
          },
          items: <String>[
            'Sedentary: little or no exercise',
            'Light: exercise 1-3 times/week',
            'Moderate: exercise 4-5 time/week',
            'Active: daily exercise or intense            \nexercise 3-4 times/week',
            'Very Active: intense exercise 6-7            \n times/week',
            'Extra Active: very intense exercise          \ndaily, or physical job'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w300
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0,20 ),
                  child: Text(
                    'Additional Details',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildName(),
                SizedBox(height: 10,),
                _buildAge(),
                SizedBox(height: 10,),
                _buildGender(),
                SizedBox(height: 10,),
                _buildHeight(),
                SizedBox(height: 10,),
                _buildWeight(),
                SizedBox(height: 10,),
                _buildActivity(),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child:  Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: (){
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      setState(() {
                        _formKey.currentState.save();
                      });
                      UserData userData = UserData(
                        name: _name,
                        age: _age,
                        isMale: _isMale,
                        height: _height,
                        weight: _weight,
                        activityLevel: _activityLevel
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => PlanScreen(userData: userData)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
