import 'dart:io';
import 'package:dietmate/shared/conversion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  final UserData userData;
  AdditionalDetailsScreen({this.userData});
  @override
  _AdditionalDetailsScreenState createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {

  String _name;
  int _age;
  bool _isMale = true;
  int _height;
  int _weight;
  double _activityLevel = 1.2;
  String _activity = 'Sedentary: little or no exercise';
  String _joinDate = '';
  String _profileUrl = 'https://rpgplanner.com/wp-content/uploads/2020/06/no-photo-available.png';
  Map caloriePlan= {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool uploading=false;

  File _image;
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    if(widget.userData!=null){
      _name=widget.userData.name;
      _age=widget.userData.age;
      _isMale=widget.userData.isMale;
      _height=widget.userData.height;
      _weight=widget.userData.weight;
      _activityLevel=widget.userData.activityLevel;
      _joinDate=widget.userData.joinDate;
      _profileUrl=widget.userData.userProfileUrl;
      // switch (_activityLevel){
      //   case 1.2 :{
      //     _activity='Sedentary: little or no exercise';
      //   }
      //   break;
      //   case 1.375 :{
      //     _activity='Light: exercise 1-3 times/week';
      //   }
      //   break;
      //   case 1.465:{
      //     _activity='Moderate: exercise 4-5 time/week';
      //   }
      //   break;
      //   case 1.55:{
      //     _activity='Active: daily exercise or intense exercise 3-4 times/week';
      //   }
      //   break;
      //   case 1.725:{
      //     _activity='Very Active: intense exercise 6-7 times/week';
      //   }
      //   break;
      //   case 1.9:{
      //     _activity= 'Extra Active: very intense exercise daily, or physical job';
      //   }
      //   break;
      // }
    }
  }

  Future uploadFile(User user) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('UserProfiles/${user.uid}/pic1.jpeg')
          .putFile(_image);
    } on Exception catch (e) {
      print('Failed - $e');
    }
    try {
      var result = await firebase_storage.FirebaseStorage.instance
          .ref('UserProfiles/${user.uid}/pic1.jpeg')
          .getDownloadURL();
      _profileUrl=result;
      print('profileUrl: $_profileUrl');
    } on Exception catch (e) {
      print('Failed - $e');
    }

  }

  Future getImageFromCamera() async{
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState((){
      if(pickedImage != null){
        _image = File(pickedImage.path);
        print(_image.path);
      }else{
        print("No Image Selected");
      }
    });
  }

  Future getImageFromGallery() async{
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState((){
      if(pickedImage != null){
        _image = File(pickedImage.path);
        print(_image.path);
      }else{
        print("No Image Selected");
      }
    }
    );
  }

  Widget _buildImagePicker(BuildContext context, User user){
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Camera'),
            onTap: () async {
              print('pressed');
              await getImageFromCamera();
              if(_image!=null){
                await showDialog(context: context, builder: (context)=>_buildImageDialog(user));
              }
              setState(() {
                Navigator.pop(context);
              });
            }
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Gallery'),
            onTap: () async {
              print('pressed');
              await getImageFromGallery();
              if(_image!=null){
                await showDialog(context: context, builder: (context)=>_buildImageDialog(user));
              }
              setState(() {
                Navigator.pop(context);
              });
            }
          ),
        ],
      ),
    );
  }

  Widget _buildImageDialog(User user){
    Size size = MediaQuery.of(context).size;
    return Dialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: size.height*0.54,
        width: size.width*0.9,
        child: Column(
          children: [
            Container(
              height: size.width*0.9,
              width: size.width*0.9,
              child: Image.file(
                _image,
                fit: BoxFit.cover,
              ),
            ),
            uploading==true?Container(
              padding: EdgeInsets.only(top: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10,),
                  Text(
                    'Uploading..',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ):
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      uploading=true;
                    });
                    await uploadFile(user);
                    setState(() {
                      uploading=false;
                    });
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  onPressed: () {
                    _image=null;
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, User user){
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(70),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder:(context){
              return _buildImagePicker(context, user);
            }
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(_profileUrl),
          radius: 70,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              _image==null?Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black87.withOpacity(0.5),
                  child: Icon(Icons.camera_alt_outlined, size: 35,color: Theme.of(context).accentColor)
                ),
              ):SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName(){
    return TextFormField(
      initialValue: _name,
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
      initialValue: _age.toString()=='null'?'':_age.toString(),
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
      initialValue: _height.toString()=='null'?'':_height.toString(),
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
      initialValue: _weight.toString()=='null'?'':_weight.toString(),
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
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
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
            width: MediaQuery.of(context).size.width,
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
            'Active: daily exercise or intense exercise 3-4 times/week',
            'Very Active: intense exercise 6-7 times/week',
            'Extra Active: very intense exercise daily, or physical job'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width*0.8,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w300
                  ),
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

    User user = Provider.of<User>(context);

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
                SizedBox(height: 5),
                _buildProfile(context, user),
                SizedBox(height: 15),
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
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      setState(() {
                        _formKey.currentState.save();
                      });
                      switch (_activity){
                        case 'Sedentary: little or no exercise' :{
                          _activityLevel=1.2;
                        }
                        break;
                        case 'Light: exercise 1-3 times/week':{
                          _activityLevel=1.375;
                        }
                        break;
                        case 'Moderate: exercise 4-5 time/week':{
                          _activityLevel=1.465;
                        }
                        break;
                        case 'Active: daily exercise or intense exercise 3-4 times/week':{
                          _activityLevel=1.55;
                        }
                        break;
                        case 'Very Active: intense exercise 6-7 times/week':{
                          _activityLevel=1.725;
                        }
                        break;
                        case 'Extra Active: very intense exercise daily, or physical job':{
                          _activityLevel=1.9;
                        }
                        break;
                        default:{
                          _activityLevel=1;
                        }
                      }
                      double bmr=0;
                      if(_isMale){
                        bmr=10*_weight+6.25*_height-5*_age+5;
                      }
                      else{
                        bmr=10*_weight+6.25*_height-5*_age-161;
                      }
                      bmr=bmr*_activityLevel;
                      caloriePlan['gain']=bmr*1.15;
                      caloriePlan['maintain']=bmr;
                      caloriePlan['mildLoss']=bmr*0.88;
                      caloriePlan['weightLoss']=bmr*0.75;
                      caloriePlan['extLoss']=bmr*0.5;
                      if (_joinDate=='') {
                        DateTime now = DateTime.now();
                        _joinDate=dateToString(now);
                      }
                      UserData userData = UserData(
                        name: _name,
                        age: _age,
                        isMale: _isMale,
                        height: _height,
                        weight: _weight,
                        activityLevel: _activityLevel,
                        joinDate: _joinDate,
                        userProfileUrl: _profileUrl
                      );
                      print(userData.userProfileUrl);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => PlanScreen(userData: userData,caloriePlan: caloriePlan,)),
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
