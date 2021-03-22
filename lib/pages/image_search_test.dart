import 'dart:convert';
import 'package:dietmate/model/image_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ImageSearch extends StatefulWidget {
  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {

  String searchQuery;
  GlobalKey<FormState> _imgFormKey = GlobalKey<FormState>();
  bool isSearching=false;
  bool searchDone=false;
  var searchResult;
  FoodImage foodImage1, foodImage2, foodImage3;
  List<String> imgList=[];

  Future<dynamic> getImages(String query) async {
    Client _client = Client();
    const String _baseUrl = "contextualwebsearch-websearch-v1.p.rapidapi.com";
    Response response = await _client
        .get(Uri.https(_baseUrl, "/api/Search/ImageSearchAPI",
        {"q": query, "pageNumber": "1", "pageSize":"3", "autoCorrect":"true"}),
        headers: {
          "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
          "x-rapidapi-host": "contextualwebsearch-websearch-v1.p.rapidapi.com",
        }
    );
    Map data=jsonDecode(response.body);
    print(data);
    return data;
  }

  Widget _buildSearchQuery(){
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Food Name',
          labelStyle: TextStyle(fontSize: 25)
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
        searchQuery = value;
      },
    );
  }

  Widget _buildImgList(List<String> imgList){
    print(imgList);
    return Image.network(imgList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _imgFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildSearchQuery(),
              isSearching==true?Column(
                children: [
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                ],
              ):SizedBox.shrink(),
              searchDone==true?_buildImgList(imgList):SizedBox.shrink(),
              Builder(builder: (context) => ElevatedButton(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
                onPressed: () async {
                  setState(() {
                    if (!_imgFormKey.currentState.validate()) {
                      return;
                    }
                    isSearching=true;
                    _imgFormKey.currentState.save();
                  });
                  searchResult=await getImages(searchQuery);
                  foodImage1=FoodImage.fromData(searchResult, 0);
                  imgList.add(foodImage1.fullUrl);
                  setState(() {
                    isSearching=false;
                    searchDone=true;
                  });
                },
              )),
            ],
          ),
        )
      ),
    );
  }
}
