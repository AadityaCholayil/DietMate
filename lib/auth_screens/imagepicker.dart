import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePicker extends StatefulWidget{
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker>{

  File _image;
  final picker = ImagePicker();

  Future getImagefromCamera() async{
    final pickedImage = await picker.getImage(source: ImageSource.camera);

    setState((){
      if(pickedImage != null){
        _image = File(pickedImage.path);
      }else{
        print("No Image Selected");
      }
    }
    );
  }

  Future getImagefromGallery() async{
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState((){
      if(pickedImage != null){
        _image = File(pickedImage.path);
      }else{
        print("No Image Selected");
      }
    }
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top:30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text('Edit Profile'),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.circle),
                width: MediaQuery.of(context).size.width,
                height:200.0,
                child: Center(
                  child: _image == null ? Text("No image selected"): Image.file(_image),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: getImagefromCamera,
                  tooltip: "Pick Image from Camera",
                  child: Icon(Icons.camera),
                ),
                FloatingActionButton(
                  onPressed: getImagefromGallery,
                  tooltip: "Pick Image from Gallery",
                  child: Icon(Icons.folder),
                ),
              ],
            )
          ],
        ),
      ),

    );
  }
}