import 'dart:convert';
import 'package:animations/animations.dart';
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
        {"q": query, "pageNumber": "1", "pageSize":"20", "autoCorrect":"true"}),
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

  Widget customImage(FoodImage image){
    return OpenContainer(
      openBuilder: (context, closedBuilder){
        return Container(
          color: Colors.red,
        );
      },
      closedBuilder:(context, openContainer) {
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
              },
            ),
          ),
          onTap: (){
            openContainer();
          },
        );
      }
    );
  }

  Widget _buildImgList(FoodImages imageList){
    //imageList.foodImageList[0];
    return Column(
      children: [
        GridView.count(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 12),
          primary: false,
          shrinkWrap: true,
          //padding: EdgeInsets.all(10),
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 3,
          children: <Widget>[
            customImage(imageList.img1),
            customImage(imageList.img2),
            customImage(imageList.img3),
            customImage(imageList.img4),
            customImage(imageList.img5),
            customImage(imageList.img6),
            customImage(imageList.img7),
            customImage(imageList.img8),
            customImage(imageList.img9),
          ],
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
              searchDone==true?_buildImgList(foodImages):SizedBox.shrink(),
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
                  foodImages=FoodImages.fromData(searchResult);
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
