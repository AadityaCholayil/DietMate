import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mid_${Theme.of(context).brightness==Brightness.light?'light':'dark'}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
