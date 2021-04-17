import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/food.dart';
import 'package:dietmate/model/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
    }).then((value) => print('Updated!'));
  }

  //add food
  Future addFood(Food food) async {
    return await db.collection('users').doc(uid).collection('foods').add({
      'date': food.date,
      'week': food.week,
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
    );
  }

  Stream<UserData> get userData{
    return db.collection('users').doc(uid).snapshots()
      .map(_userDataFromSnapshot).handleError((onError){print('error');});
  }
}