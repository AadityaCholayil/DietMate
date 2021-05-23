import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  //userData Stream
  Stream<UserData> get userData{
    print('UserData Stream updated');
    return db.collection('users').doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  //write UserData
  Future setUserData(UserData userData) async {
    return await db.collection('users').doc(uid).set({
      'name': userData.name,
      'age': userData.age,
      'isMale': userData.isMale,
      'height': userData.height,
      'weight': userData.weight,
      'activityLevel': userData.activityLevel,
      'calorieGoal': userData.calorieGoal,
      'joinDate': userData.joinDate,
      'userProfileUrl': userData.userProfileUrl,
    });
  }

  Future updateUserData(UserData userData) async {
    return await db.collection('users').doc(uid).update({
      'name': userData.name,
      'age': userData.age,
      'isMale': userData.isMale,
      'height': userData.height,
      'weight': userData.weight,
      'activityLevel': userData.activityLevel,
      'calorieGoal': userData.calorieGoal,
      'joinDate': userData.joinDate,
      'userProfileUrl': userData.userProfileUrl,
    }).then((value) => print('Updated!'));
  }

  //user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      age: snapshot.data()['age'],
      isMale: snapshot.data()['isMale'],
      height: snapshot.data()['height'],
      weight: snapshot.data()['weight'],
      activityLevel: snapshot.data()['activityLevel'],
      calorieGoal: snapshot.data()['calorieGoal'],
      joinDate: snapshot.data()['joinDate'],
      userProfileUrl: snapshot.data()['userProfileUrl'],
    );
  }

  //add food
  Future addFood(Food food) async {
    return await db.collection('users').doc(uid).collection('foods').add({
      'date': food.date,
      'time': food.time,
      'timestamp': food.timestamp,
      'name': food.name,
      'calories': food.calories,
      'fats': food.fats,
      'protein': food.protein,
      'carbohydrates': food.carbohydrates,
      'servingSizeQty': food.servingSizeQty,
      'servingSizeUnit': food.servingSizeUnit,
      'fullUrl': food.fullUrl,
      'thumbnailUrl': food.thumbnailUrl,
      'imageWidth': food.imageWidth,
      'imageHeight': food.imageHeight,
    }).then((value) => print("Food Added"))
        .catchError((error) {
      print("Failed to add food: $error");
      return 'error';
    });
  }

  //Update food
  Future updateFood(Food food) async {
    return await db.collection('users').doc(uid).collection('foods').doc(food.uid).update({
      'date': food.date,
      'time': food.time,
      'timestamp': food.timestamp,
      'name': food.name,
      'calories': food.calories,
      'fats': food.fats,
      'protein': food.protein,
      'carbohydrates': food.carbohydrates,
      'servingSizeQty': food.servingSizeQty,
      'servingSizeUnit': food.servingSizeUnit,
      'fullUrl': food.fullUrl,
      'thumbnailUrl': food.thumbnailUrl,
      'imageWidth': food.imageWidth,
      'imageHeight': food.imageHeight,
    }).then((value) => print("Food Updated"))
        .catchError((error) {
      print("Failed to update food: $error");
      return 'error';
    });
  }

  Future deleteFood(Food food) async {
    return await db.collection('users')
        .doc(uid)
        .collection('foods')
        .doc(food.uid)
        .delete()
        .then((value) => print("Food Deleted"))
        .catchError((error) {
          print("Failed to delete food: $error");
          return 'error';
        });
  }

}