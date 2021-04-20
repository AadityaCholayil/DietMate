import 'package:flutter/material.dart';
final ThemeData darkTheme = ThemeData(
  // primarySwatch: MaterialColor(4280361249,{50: Color( 0xfff2f2f2 )
  //   , 100: Color( 0xffe6e6e6 )
  //   , 200: Color( 0xffcccccc )
  //   , 300: Color( 0xffb3b3b3 )
  //   , 400: Color( 0xff999999 )
  //   , 500: Color( 0xff808080 )
  //   , 600: Color( 0xff666666 )
  //   , 700: Color( 0xff4d4d4d )
  //   , 800: Color( 0xff333333 )
  //   , 900: Color( 0xff191919 )
  // }),
  primarySwatch: MaterialColor(0xffb82fd0,{50: Color( 0xfff8eafa )
    , 100: Color( 0xfff1d5f6 )
    , 200: Color( 0xffe3acec )
    , 300: Color( 0xffd582e3 )
    , 400: Color( 0xffc659d9 )
    , 500: Color( 0xffb82fd0 )
    , 600: Color( 0xff9326a6 )
    , 700: Color( 0xff6f1c7d )
    , 800: Color( 0xff4a1353 )
    , 900: Color( 0xff25092a )
  }),
  brightness: Brightness.dark,
  primaryColor: Color( 0xff212121 ),
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: Color( 0xffde9ee9 ),
  primaryColorDark: Color( 0xff000000 ),
  accentColor: Color( 0xff9D06FF ),
  accentColorBrightness: Brightness.light,
  // canvasColor: Color( 0xff303030 ),
  canvasColor: Color( 0xff191919 ),
  scaffoldBackgroundColor: Color( 0xff191919 ),
  bottomAppBarColor: Color( 0xff303030 ),
  cardColor: Color( 0xff303030 ),
  dividerColor: Color( 0x1fffffff ),
  highlightColor: Color( 0x40cccccc ),
  splashColor: Color( 0x40cccccc ),
  selectedRowColor: Color( 0xfff5f5f5 ),
  unselectedWidgetColor: Color( 0xb3ffffff ),
  disabledColor: Color( 0x62ffffff ),
  buttonColor: Color( 0xff1e88e5 ),
  toggleableActiveColor: Color( 0xff8C0EFF ),
  secondaryHeaderColor: Color( 0xff616161 ),
  backgroundColor: Color( 0xff616161 ),
  dialogBackgroundColor: Color( 0xff424242 ),
  indicatorColor: Color( 0xffb82fd0 ),
  hintColor: Color( 0x80ffffff ),
  errorColor: Color( 0xffd32f2f ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Color( 0xff9D06FF ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      onPrimary: Color( 0xff9D06FF ),
    ),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    minWidth: 88,
    height: 36,
    padding: EdgeInsets.only(top:0,bottom:0,left:16, right:16),
    shape:     RoundedRectangleBorder(
      side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    )
    ,
    alignedDropdown: false ,
    buttonColor: Color( 0xff1e88e5 ),
    disabledColor: Color( 0x61ffffff ),
    highlightColor: Color( 0x29ffffff ),
    splashColor: Color( 0x1fffffff ),
    focusColor: Color( 0x1fffffff ),
    hoverColor: Color( 0x0affffff ),
    colorScheme: ColorScheme(
      primary: Color( 0xffde9ee9 ),
      primaryVariant: Color( 0xff6f1c7d ),
      secondary: Color( 0xffb82fd0 ),
      secondaryVariant: Color( 0xff6f1c7d ),
      surface: Color( 0xff303030 ),
      background: Color( 0xff616161 ),
      error: Color( 0xffd32f2f ),
      onPrimary: Color( 0xffffffff ),
      onSecondary: Color( 0xff000000 ),
      onSurface: Color( 0xffffffff ),
      onBackground: Color( 0xffffffff ),
      onError: Color( 0xff000000 ),
      brightness: Brightness.dark,
    ),
  ),
  inputDecorationTheme:   InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    helperStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hintStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorStyle: TextStyle(
      color: Color( 0xffd32f2f ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorMaxLines: null,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    isDense: false,
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
    //contentPadding: EdgeInsets.fromLTRB(13, 15, 13, 15),
    isCollapsed : false,
    prefixStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    suffixStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    counterStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    filled: true,
    fillColor: Color( 0xff303030 ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xffd32f2f ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff9D06FF ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xffd32f2f ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    ),
  ),
  iconTheme: IconThemeData(
    color: Color( 0xffffffff ),
    opacity: 1,
    size: 24,
  ),
  primaryIconTheme: IconThemeData(
    color: Color( 0xffffffff ),
    opacity: 1,
    size: 24,
  ),
  // accentIconTheme: IconThemeData(
  //   color: Color( 0xff000000 ),
  //   opacity: 1,
  //   size: 24,
  // ),
  sliderTheme: SliderThemeData(
    activeTrackColor: null,
    inactiveTrackColor: null,
    disabledActiveTrackColor: null,
    disabledInactiveTrackColor: null,
    activeTickMarkColor: null,
    inactiveTickMarkColor: null,
    disabledActiveTickMarkColor: null,
    disabledInactiveTickMarkColor: null,
    thumbColor: null,
    disabledThumbColor: null,
    thumbShape: null,
    overlayColor: null,
    valueIndicatorColor: null,
    valueIndicatorShape: null,
    showValueIndicator: null,
    valueIndicatorTextStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Color( 0xffffffff ),
    unselectedLabelColor: Color( 0xb2ffffff ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color( 0x1fffffff ),
    brightness: Brightness.dark,
    deleteIconColor: Color( 0xdeffffff ),
    disabledColor: Color( 0x0cffffff ),
    labelPadding: EdgeInsets.only(top:0,bottom:0,left:8, right:8),
    labelStyle: TextStyle(
      color: Color( 0xdeffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top:4,bottom:4,left:4, right:4),
    secondaryLabelStyle: TextStyle(
      color: Color( 0x3dffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    secondarySelectedColor: Color( 0x3d212121 ),
    selectedColor: Color( 0x3dffffff ),
    shape: StadiumBorder( side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ) ),
  ),
  dialogTheme: DialogTheme(
      shape:     RoundedRectangleBorder(
        side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ),
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      )

  ),
);
