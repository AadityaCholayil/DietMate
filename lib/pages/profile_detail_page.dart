import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Profile Page\n(Nupoor)',
          style: TextStyle(
            fontSize: 40,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

