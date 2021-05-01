import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      //color: Theme.of(context).canvasColor,
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        child: SleekCircularSlider(
            appearance: CircularSliderAppearance(
              //size: 200,
              spinnerMode: true,
              customWidths: CustomSliderWidths(
                progressBarWidth: 8,
                trackWidth: 1
              ),
              customColors: CustomSliderColors(
                  trackColor: Theme.of(context).primaryColorLight,
                  progressBarColors: [
                    Color( 0xffB5FF48),
                    Color( 0xff94FC13),
                    Color(0xff05B54B),
                  ]
              )
            )
        ),
      ),
    );
  }
}

