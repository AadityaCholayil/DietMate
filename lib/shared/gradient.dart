import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {

  final double extraPaddingWidth;
  final double extraPaddingHeight;
  final Text label;
  final Function() onPressed;
  final bool expanded;
  final double radius;

  GradientButton({Text label, double extraPaddingHeight, double extraPaddingWidth, Function() onPressed, bool expanded, double radius}):
    this.label=label??'',
    this.extraPaddingHeight=extraPaddingHeight??0.0,
    this.extraPaddingWidth=extraPaddingWidth??0.0,
    this.onPressed=onPressed??null,
    this.expanded=expanded??false,
    this.radius=radius??10.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      //splashColor: Colors.white,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Container(
          alignment: expanded?Alignment.center:null,
          padding: EdgeInsets.symmetric(horizontal: 15.0 + extraPaddingWidth??0,
              vertical: 5.0 + extraPaddingHeight??0),
          decoration: BoxDecoration(
              gradient: customGradient
          ),
          child: label,
        ),
      ),
      onTap: onPressed,
    );
  }
}

class GradientText extends StatelessWidget {
  GradientText(text, {size, underline, fontWeight})
    :this.text=text??'',
     this.size=size??10.0,
     this.underline=underline??false,
     this.fontWeight=fontWeight??FontWeight.normal;

  final String text;
  final double size;
  final bool underline;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => customGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: size,
          decoration: underline?TextDecoration.underline:TextDecoration.none,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

LinearGradient customGradient = LinearGradient(
  // center: Alignment.topLeft,
  // radius: 1.55,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color( 0xffB5FF48),
    Color( 0xff94FC13),
    Color(0xff05B54B),
    // Colors.indigoAccent[700],
  ],
);

LinearGradient customGradient2 = LinearGradient(
  // center: Alignment.topLeft,
  // radius: 1.55,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.purpleAccent[100],
    //Colors.purpleAccent[700],
    Colors.deepPurpleAccent[100],
    // Colors.indigoAccent[700],
  ],
);