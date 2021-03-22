import 'package:flutter/material.dart';

class FoodImage{
  String fullUrl;
  String thumbnailUrl;

  FoodImage({this.fullUrl, this.thumbnailUrl});

  FoodImage.fromData(Map data, int hitNo){
    this.fullUrl=data['value'][hitNo]['url'];
    this.thumbnailUrl=data['value'][hitNo]['thumbnail'];
  }

}