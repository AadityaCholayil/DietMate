import 'package:dietmate/model/food.dart';

class FoodImage{
  String fullUrl;
  String thumbnailUrl;
  int height;
  int width;

  FoodImage({this.fullUrl, this.thumbnailUrl, this.height, this.width});

  FoodImage.fromData(Map data, int hitNo){
    this.fullUrl=data['value'][hitNo]['url'];
    this.thumbnailUrl=data['value'][hitNo]['thumbnail'];
    this.height=data['value'][hitNo]['height'];
    this.width=data['value'][hitNo]['width'];
  }
}

class FoodImages{
  FoodImage img1,img2,img3,img4,img5,img6,img7,img8,img9;
  int hitNo=0;
  List<FoodImage> foodImageList;

  FoodImages.fromData(Map data){
    img1=FoodImage.fromData(data, hitNoIncrement(data));
    img2=FoodImage.fromData(data, hitNoIncrement(data));
    img3=FoodImage.fromData(data, hitNoIncrement(data));
    img4=FoodImage.fromData(data, hitNoIncrement(data));
    img5=FoodImage.fromData(data, hitNoIncrement(data));
    img6=FoodImage.fromData(data, hitNoIncrement(data));
    img7=FoodImage.fromData(data, hitNoIncrement(data));
    img8=FoodImage.fromData(data, hitNoIncrement(data));
    img9=FoodImage.fromData(data, hitNoIncrement(data));
    printAllUrl();
    imagesToList();
  }

  void imagesToList(){
    foodImageList=[img1,img2,img3,img4,img5,img6,img7,img8,img9];
  }

  void printAllUrl(){
    print(img1.fullUrl);
    print(img2.fullUrl);
    print(img3.fullUrl);
    print(img4.fullUrl);
    print(img5.fullUrl);
    print(img6.fullUrl);
    print(img7.fullUrl);
    print(img8.fullUrl);
    print(img9.fullUrl);
  }

  int hitNoIncrement(Map data){
    String url=data['value'][hitNo]['url'];
    if(url.substring(0,5)=='https'){
      return hitNo++;
    }else{
      hitNo++;
      return hitNo++;
    }
  }
}
