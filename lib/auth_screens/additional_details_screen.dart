import 'dart:io';
import 'package:dietmate/services/database.dart';
import 'package:dietmate/shared/conversion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:dietmate/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
      if (_activityLevel==1.2) {
        _activity='Sedentary: little or no exercise';
      } else if (_activityLevel==1.375){
        _activity='Light: exercise 1-3 times/week';
      } else if (_activityLevel==1.465){
        _activity='Moderate: exercise 4-5 time/week';
      } else if (_activityLevel==1.55){
        _activity='Active: daily exercise or intense exercise 3-4 times/week';
      } else if (_activityLevel==1.725){
        _activity='Very Active: intense exercise 6-7 times/week';
      } else if (_activityLevel==1.9){
        _activity= 'Extra Active: very intense exercise daily, or physical job';
      } else {
        _activity='Sedentary: little or no exercise';
      }
    }
  }

   Widget _buildTextHelp(String text){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 13, bottom: 5, top: 6),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).unselectedWidgetColor,
            fontWeight: FontWeight.w400
        ),
      ),
    );
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
    if (widget.userData!=null) {
      UserData newUserData=widget.userData;
      newUserData.userProfileUrl=_profileUrl;
      await DatabaseService(uid: user.uid).updateUserData(newUserData);
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
  Future <File> cropImage(File image) async{
    int imageLength = await image.length();
    print("Before Crop $imageLength");
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
        ?<CropAspectRatioPreset>[
          CropAspectRatioPreset.square,
        ]
        :<CropAspectRatioPreset>[
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
        compressQuality: imageLength>100000? 10000000~/imageLength: 100,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.green,
          statusBarColor: Theme.of(context).cardColor,
          activeControlsWidgetColor: Colors.green,
          toolbarWidgetColor: Theme.of(context).cardColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
    ));
    if (croppedFile != null){
      return croppedFile;
    }
    return image;
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
                  _image = await cropImage(_image);
                  int imageLength = await _image.length();
                  print("Crop Image");
                  print(imageLength);
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
                  _image = await cropImage(_image);
                  int imageLength = await _image.length();
                  print("Crop Image");
                  print(imageLength);
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
    return StatefulBuilder(
      builder: (context, setState){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            height: size.width*1.035,
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
                          fontSize: 22,
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
                          fontSize: 21,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          print('pressed upload');
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
                          fontSize: 21,
                        ),
                      ),
                      onPressed: () {
                        _image=null;
                        Navigator.pop(context);
                      },
                    ),
                    // TextButton(
                    //   child: Text(
                    //     'Crop Image',
                    //     style: TextStyle(
                    //       fontSize: 21,
                    //     ),
                    //   ),
                    //   onPressed: () async{
                    //     File file = await cropImage(_image);
                    //     setState((){
                    //       _image = file;
                    //       });
                    //     int imageLength = await _image.length();
                    //     print("Crop Image");
                    //     print(imageLength);
                    //   },
                    // ),
                    SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
        );
      },

    );
  }

  Widget _buildProfile(BuildContext context, User user){
    return Container(
      //clipBehavior: Clip.antiAliasWithSaveLayer,
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
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_profileUrl),
              radius: 70,
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    _profileUrl=='https://rpgplanner.com/wp-content/uploads/2020/06/no-photo-available.png'?Expanded(
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
            _profileUrl!='https://rpgplanner.com/wp-content/uploads/2020/06/no-photo-available.png'?
            Container(
              width: 140,
              height: 140,
              padding: EdgeInsets.only(right: 3, bottom: 3),
              alignment: Alignment.bottomRight,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Icon(Icons.edit),
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildName(){
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 16),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Eg. John',
          labelStyle: TextStyle(fontSize: 23, color: Theme.of(context).disabledColor, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 16),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Eg. 19',
          labelStyle: TextStyle(fontSize: 23, color: Theme.of(context).disabledColor, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500),
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
            fontSize: 23,
            fontWeight: FontWeight.w400,
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
            fontSize: 22,
            fontWeight: FontWeight.w400,
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
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildHeight(){
    return TextFormField(
      initialValue: _height.toString()=='null'?'':_height.toString(),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 16),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Eg. 175',
          labelStyle: TextStyle(fontSize: 23, color: Theme.of(context).disabledColor, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2, style: BorderStyle.solid, ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 16),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          labelText: 'Eg. 70',
          labelStyle: TextStyle(fontSize: 23, color: Theme.of(context).disabledColor, fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500),
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
        //height: MediaQuery.of(context).size.width*0.,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.026),
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
                  _activity==value?value.length>33?"${value.substring(0,34)}..":value:value,
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
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              //height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width*(15/432)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 20, 0,20 ),
                      child: Text(
                        'Additional Details',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 5),
                    _buildProfile(context, user),
                    SizedBox(height: 15),
                    _buildTextHelp('Name'),
                    _buildName(),
                    _buildTextHelp('Age'),
                    _buildAge(),
                    _buildGender(),
                    _buildTextHelp('Height (cm)'),
                    _buildHeight(),
                    _buildTextHelp('Weight (kg)'),
                    _buildWeight(),
                    _buildTextHelp('Activity Level'),
                    _buildActivity(),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),
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
        ),
      ),
    );
  }
}
