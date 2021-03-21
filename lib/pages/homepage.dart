import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
            'Home Page\n(Nupoor)\nGitHub Branch2',
            style: TextStyle(
              fontSize: 40,
            ),
            textAlign: TextAlign.center,
          ),
      ),
    );
  }
}
