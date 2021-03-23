import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Report Page\n(Pranav)\nGithub Branch',
          style: TextStyle(
            fontSize: 40,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
