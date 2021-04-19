import 'package:flutter/material.dart';
final ThemeData lightTheme = ThemeData(
  primarySwatch: MaterialColor(4292779753,{50: Color( 0xfff8eafa )
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
  brightness: Brightness.light,
  primaryColor: Color( 0xffde9ee9 ),
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Color( 0xfff1d5f6 ),
  primaryColorDark: Color( 0xff6f1c7d ),
  accentColor: Color( 0xff9d32fe ),
  //accentColor: Color( 0xffb82fd0 ),
  // accentColor: Colors.indigoAccent[700],
  accentColorBrightness: Brightness.dark,
  canvasColor: Color( 0xfffafafa ),
  scaffoldBackgroundColor: Color( 0xfffafafa ),
  bottomAppBarColor: Color( 0xffffffff ),
  cardColor: Color( 0xffffffff ),
  dividerColor: Color( 0x1f000000 ),
  highlightColor: Color( 0x66bcbcbc ),
  splashColor: Color( 0x66c8c8c8 ),
  selectedRowColor: Color( 0xfff5f5f5 ),
  unselectedWidgetColor: Color( 0x8a000000 ),
  disabledColor: Color( 0x61000000 ),
  buttonColor: Color( 0xffe0e0e0 ),
  toggleableActiveColor: Color( 0xff9326a6 ),
  secondaryHeaderColor: Color( 0xfff8eafa ),
  backgroundColor: Color( 0xffe3acec ),
  dialogBackgroundColor: Color( 0xffffffff ),
  indicatorColor: Color( 0xffb82fd0 ),
  hintColor: Color( 0x8a000000 ),
  errorColor: Color( 0xffd32f2f ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Color( 0xffde9ee9 ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      onPrimary: Color( 0xffb82fd0 ),
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
    buttonColor: Color( 0xffe0e0e0 ),
    disabledColor: Color( 0x61000000 ),
    highlightColor: Color( 0x29000000 ),
    splashColor: Color( 0x1f000000 ),
    focusColor: Color( 0x1f000000 ),
    hoverColor: Color( 0x0a000000 ),
    colorScheme: ColorScheme(
      primary: Color( 0xffde9ee9 ),
      primaryVariant: Color( 0xff6f1c7d ),
      secondary: Color( 0xffb82fd0 ),
      secondaryVariant: Color( 0xff6f1c7d ),
      surface: Color( 0xffffffff ),
      background: Color( 0xffe3acec ),
      error: Color( 0xffd32f2f ),
      onPrimary: Color( 0xff000000 ),
      onSecondary: Color( 0xffffffff ),
      onSurface: Color( 0xff000000 ),
      onBackground: Color( 0xff000000 ),
      onError: Color( 0xffffffff ),
      brightness: Brightness.light,
    ),
  ),
  inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
    labelStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    helperStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hintStyle: TextStyle(
      color: Color( 0xdd000000 ),
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
    //contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
    isCollapsed : false,
    prefixStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    suffixStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    counterStyle: TextStyle(
      color: Color( 0xdd000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    filled: false,
    fillColor: Color( 0x00000000 ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xffd32f2f ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xffb82fd0 ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xffd32f2f ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0x61000000 ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color( 0xff000000 ), width: 2, style: BorderStyle.solid, ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
  iconTheme: IconThemeData(
    color: Color( 0xdd000000 ),
    opacity: 1,
    size: 24,
  ),
  primaryIconTheme: IconThemeData(
    color: Color( 0xff000000 ),
    opacity: 1,
    size: 24,
  ),
  // accentIconTheme: IconThemeData(
  //   color: Color( 0xffffffff ),
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
    //thumbShape: null,
    overlayColor: null,
    valueIndicatorColor: null,
    //valueIndicatorShape: null,
    showValueIndicator: null,
    valueIndicatorTextStyle: TextStyle(
      color: Color( 0xffffffff ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Color( 0xdd000000 ),
    unselectedLabelColor: Color( 0xb2000000 ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color( 0x1f000000 ),
    brightness: Brightness.light,
    deleteIconColor: Color( 0xde000000 ),
    disabledColor: Color( 0x0c000000 ),
    labelPadding: EdgeInsets.only(top:0,bottom:0,left:8, right:8),
    labelStyle: TextStyle(
      color: Color( 0xde000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top:4,bottom:4,left:4, right:4),
    secondaryLabelStyle: TextStyle(
      color: Color( 0x3d000000 ),
      fontSize: null,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    secondarySelectedColor: Color( 0x3dde9ee9 ),
    selectedColor: Color( 0x3d000000 ),
    shape: StadiumBorder( side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ) ),
  ),
  dialogTheme: DialogTheme(
      shape:     RoundedRectangleBorder(
        side: BorderSide(color: Color( 0xff000000 ), width: 0, style: BorderStyle.none, ),
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      )

  ),
);
