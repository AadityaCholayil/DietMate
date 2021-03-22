import 'dart:convert';
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
  Image image1, image2, image3;
  List<String> imgList=[];

  Future<dynamic> getImagesByName(String query) async {
    Client _client = Client();
    const String _apiKey = "gqDMu5m4NrqfExqrZh6jecOdbS_6K0WFXsaOw4Ve9JE";
    const String _baseUrl = "api.unsplash.com";
    Response response;
    Map data;
    response = await _client
        .get(Uri.https(_baseUrl, "/search/photos", {"page": "1", "query": query, "client_id": _apiKey}));
    data=jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200)
      return data;
    else
      return response.statusCode.toString();
  }

  Future<dynamic> getImages(String query) async {
    Client _client = Client();
    const String _baseUrl = "https://contextualwebsearch-websearch-v1.p.rapidapi.com";
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
                  searchResult=await getImagesByName(searchQuery);
                  print(searchResult['results'][0]['urls']['regular']);
                  imgList.add('${searchResult['results'][0]['urls']['regular']}');

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
