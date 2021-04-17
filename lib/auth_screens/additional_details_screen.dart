import 'package:dietmate/auth_screens/plan_screen.dart';
import 'package:flutter/material.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  @override
  _AdditionalDetailsScreenState createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {

  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Additional Details Page',
              style: TextStyle(
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              child:  Text(
                'Next',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => PlanScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
