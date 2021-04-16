import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/model/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  //write UserData
  Future updateUserData(UserData userData) async {
    return await db.collection('users').doc(uid).set({
      'name': userData.name,
      'age': userData.age,
      'isMale': userData.isMale,
      'height': userData.height,
      'weight': userData.weight,
      'activityLevel': userData.activityLevel,
      'isDarkMode': userData.isDarkMode,
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
      isDarkMode: snapshot.data()['isDarkMode']
    );
  }

  Stream<UserData> get userData{
    return db.collection('users').doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
}