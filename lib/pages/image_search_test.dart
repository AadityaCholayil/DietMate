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
  FoodImages foodImages;

  Future<dynamic> getImages(String query) async {
    Client _client = Client();
    const String _baseUrl = "contextualwebsearch-websearch-v1.p.rapidapi.com";
    Response response = await _client
        .get(Uri.https(_baseUrl, "/api/Search/ImageSearchAPI",
        {"q": query, "pageNumber": "1", "pageSize":"15", "autoCorrect":"true"}),
        headers: {
          "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
          "x-rapidapi-host": "contextualwebsearch-websearch-v1.p.rapidapi.com",
        }
    );
    Map data=jsonDecode(response.body);
    print(data);
    if(data['totalCount']==0){
      return 'No results';
    }
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

  Widget customImage(FoodImage image){
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.network(
          image.fullUrl,
          fit: image.width>image.height? BoxFit.fitHeight : BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
            return loadingProgress==null?
            child:
            CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ?
              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                  : null,
            );
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
            return Image.network(
              'https://www.pacificfoodmachinery.com.au/media/catalog/product/placeholder/default/no-product-image-400x400.png',
              fit: BoxFit.fill,
            );
            //return SizedBox.shrink();
          },
        ),
      ),
      onTap: (){
        Navigator.pop(context, image);
      },
    );
  }

  Widget _buildImageList(FoodImages foodImages){
    if(foodImages.foodImageList.length==0){
      return Text('No results found');
    }
    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 12),
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (BuildContext context, int index){
            return customImage(foodImages.foodImageList[index]);
          },
          itemCount: foodImages.foodImageList.length,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              searchDone==true?_buildImageList(foodImages):SizedBox.shrink(),
              Builder(builder: (context) => ElevatedButton(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
                onPressed: () async {
                  if (!_imgFormKey.currentState.validate()) {
                    return;
                  }
                  setState(() {
                    isSearching=true;
                    searchDone=false;
                    _imgFormKey.currentState.save();
                  });
                  searchResult=await getImages(searchQuery);
                  if(searchResult=='No results'){
                    foodImages=FoodImages(foodImageList: []);
                  }else{
                    foodImages=FoodImages.fromData(searchResult);
                  }
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