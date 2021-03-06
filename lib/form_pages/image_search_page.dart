import 'dart:convert';
import 'dart:ui';
import 'package:dietmate/model/food_image.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ImageSearch extends StatefulWidget {
  final String query;
  ImageSearch({this.query});
  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {

  String searchQuery, foodName='';
  GlobalKey<FormState> _imgFormKey = GlobalKey<FormState>();
  bool isSearching=false;
  bool searchDone=false;
  var searchResult;
  FoodImages foodImages;
  int selectedImage=10;

  @override
  void initState() {
    super.initState();
    foodName=widget.query;
  }

  Future<dynamic> getImages(String query) async {
    Client _client = Client();
    Response response = await _client.get(
        Uri.http("athul0491.pythonanywhere.com","/image/$query")
    );
    // const String _baseUrl = "contextualwebsearch-websearch-v1.p.rapidapi.com";
    // Response response = await _client
    //     .get(Uri.https(_baseUrl, "/api/Search/ImageSearchAPI",
    //     {"q": query, "pageNumber": "1", "pageSize":"15", "autoCorrect":"true"}),
    //     headers: {
    //       "x-rapidapi-key": "9b837a32d8mshd72f108cc18a5ebp160760jsnc13d929cb7fd",
    //       "x-rapidapi-host": "contextualwebsearch-websearch-v1.p.rapidapi.com",
    //     }
    // );
    Map data=jsonDecode(response.body);
    print(data);
    if(data['totalCount']==0){
      return 'No results';
    }
    return data;
  }

  Widget _buildSearchQuery(){
    return TextFormField(
      initialValue: foodName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 18, 15, 18),
          filled: true,
          fillColor: Theme.of(context).buttonColor,
          labelText: 'Food Name',
          labelStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8C8C8C)
          ),
          suffixIcon: Icon(Icons.search, size: 28),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      keyboardType: TextInputType.name,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
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

  Widget customImage(FoodImage image, int index){
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          boxShadow: index==selectedImage?[
            BoxShadow(color: Theme.of(context).accentColor, spreadRadius: 3)
          ]:[],
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 60,
                width: 60,
              ),
            ),
            ImageFiltered(
              imageFilter: selectedImage==index?
                ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5):
                ImageFilter.blur(),
              child: Image.network(
                image.fullUrl,
                fit: image.width>image.height? BoxFit.fitHeight : BoxFit.fitWidth,
                //fit: BoxFit.contain,
                // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                //   return loadingProgress==null? child :
                //   Center(
                //     child: SizedBox(
                //       height: 50,
                //       width: 50,
                //       child: CircularProgressIndicator(
                //         value: loadingProgress.expectedTotalBytes != null ?
                //         loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                //             : null,
                //       ),
                //     ),
                //   );
                // },
                errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace){
                  return Image.network(
                    'https://www.pacificfoodmachinery.com.au/media/catalog/product/placeholder/default/no-product-image-400x400.png',
                    fit: BoxFit.fill,
                  );
                  //return SizedBox.shrink();
                },
              ),
            ),
            selectedImage==index?Center(
              child: ElevatedButton(
                child: Text(
                  'Select',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.white
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, image);
                },
              ),
            ):SizedBox.shrink(),
          ],
        ),
      ),
      onTap: (){
        setState(() {
          selectedImage=index;
        });
      },
    );
  }

  Widget _buildImageList(FoodImages foodImages){
    if(foodImages.foodImageList.length==0){
      return Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          'No results found.',
          style: TextStyle(
            fontSize: 23
          ),
        ),
      );
    }
    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 12),
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (BuildContext context, int index){
            return customImage(foodImages.foodImageList[index], index);
          },
          itemCount: foodImages.foodImageList.length,
        ),
      ],
    );
  }

  Widget _buildTitle(){
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
        alignment: Alignment.center,
        child: Text(
          'Image Search',
          style: TextStyle(
            fontSize: 43,
            fontWeight: FontWeight.bold,
            color: Color( 0xFF2ACD07),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/search_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _imgFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitle(),
                  _buildSearchQuery(),
                  SizedBox(height: 20),
                  isSearching==true?Column(
                    children: [
                      SizedBox(height: 20),
                      LoadingSmall(color: Color( 0xFF2ACD07)),
                      SizedBox(height: 20),
                    ],
                  ):SizedBox.shrink(),
                  searchDone==true?_buildImageList(foodImages):SizedBox.shrink(),
                  Builder(builder: (context) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        primary: Color(0xFF2ACD07),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
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
                  SizedBox(height: 40,)
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
