import 'package:flutter/material.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  @override
  _AdditionalDetailsScreenState createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Additional Details Page',
          style: TextStyle(
            fontSize: 40,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
