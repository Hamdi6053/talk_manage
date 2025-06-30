import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:get/get.dart";

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = Color.fromRGBO(78, 90, 232, 1);
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    // Scaffold arka planını ekledim
    scaffoldBackgroundColor: Colors.white,
    // Genel arka plan rengi
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.blue,
      secondary: Colors.purple,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      elevation: 0,
    ),
    // Input field'lar için
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
    ),
    dividerColor: Colors.grey[300],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.grey[800]),
    ),
  );

  static final dark = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    // Scaffold arka planını ekledim
    scaffoldBackgroundColor: Colors.black,
    // Genel arka plan rengi
    colorScheme: ColorScheme.dark(
      surface: Colors.grey[900]!,
      primary: primaryClr,
      secondary: Colors.purple,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      elevation: 0,
    ),
    // Input field'lar için
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[900],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[600]!),
      ),
    ),
    dividerColor: Colors.grey[600],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.grey[400]),
    ),
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
    )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black
    )
  );
}

TextStyle get titleTextStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black
    )
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]
    )
  );
}