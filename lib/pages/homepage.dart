import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietmate/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  String dateToday = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateToday='${now.day}-${now.month}-${now.year}';
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: db.collection('users').doc(user.uid).collection('foods')
            .where('date', isEqualTo: dateToday).get(),
        builder: (context, snapshot){
          if(snapshot.connectionState!=ConnectionState.done){
            //query in progress
            return Loading();
          }
          if(snapshot.hasError){
            return Container(
              child: Text(
                'Error occurred',
              ),
            );
          }
          if(snapshot.hasData){
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            if(documents.isEmpty){
              //query successful but is empty
              return Container(
                child: Text(
                    'Empty'
                ),
              );
            }
            //main code
            return Container(
              child: Text(
                  'Got data (${documents.length} doc/s)'
              ),
            );
          }
          return Container(
            child: Text(
                'Something went wrong'
            ),
          );
        },
      )
    );
  }
}
