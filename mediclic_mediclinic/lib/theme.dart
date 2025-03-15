import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeClass {
  Color lightPrimaryColor = HexColor("#DF0054");
  Color darkPrimaryColor = HexColor(" #480032");
  Color secondaryColor = HexColor("# FF8B6A");
  Color accentColor = HexColor(" #FFD2BB");


  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themesClass.lightPrimaryColor,
      secondary: _themesClass.secondaryColor
    )
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.red),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themesClass.darkPrimaryColor,
      //secondary: _themesClass.accentColor
    ),
    
  );
}

ThemeClass _themesClass = ThemeClass();
