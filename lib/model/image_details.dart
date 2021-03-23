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
  var foodImageList=[];

  FoodImages.fromData(Map data){
    int i=0;
    while(foodImageList.length<9&&i<15){
      FoodImage foodImage=FoodImage.fromData(data, i++);
      if(foodImage.fullUrl.substring(0,5)=='https'){
        foodImageList.add(foodImage);
      }
    }
    printAllUrl();
  }

  void printAllUrl(){
    for(FoodImage image in foodImageList){
      print(image.fullUrl);
    }
  }
}
