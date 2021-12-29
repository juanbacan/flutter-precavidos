import 'package:flutter/material.dart';

/*final miTema = ThemeData.dark().copyWith(
  accentColor: Colors.red
);*/

final miTema = ThemeData().copyWith(
  //accentColor: Colors.red,
  //splashColor: Colors.amber,
  primaryColor: Color.fromRGBO(0, 182, 240, 1),

  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue
  ).copyWith(
    primary: Color.fromRGBO(0, 182, 240, 1),

  ),

  //textTheme: const TextTheme()

  /*textTheme: const TextTheme(
    //caption: TextStyle(fontSize: 50.0, color: Colors.black),
    //bodyText1: TextStyle(fontSize: 50.0, color: Colors.black),
    bodyText2: TextStyle(fontSize: 50.0, color: Colors.black),
  )*/

);

// How to use:

// 
//color: Theme.of(context).colorScheme.secondary,
// style: Theme.of(context).textTheme.headline6,
/*textTheme: const TextTheme(
  headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
),*/

/*headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,*/

//fontFamily: 'Georgia',