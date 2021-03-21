import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Plan Page',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
