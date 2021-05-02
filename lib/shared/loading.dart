import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).canvasColor,
      child: Center(
        child: SpinKitFadingCircle(
          color: Theme.of(context).accentColor,
          size: 90.0,
        ),
      ),
    );
  }
}

class LoadingSmall extends StatelessWidget {

  final Color color;
  LoadingSmall({color})
      :this.color=color??null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        child:  SpinKitFadingCircle(
          color: color??Theme.of(context).accentColor,
          size: 90.0,
        ),
      ),
    );
  }
}

