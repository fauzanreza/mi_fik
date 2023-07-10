import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors
var primaryLightBG = const Color(0xFFFADFB9); // Not used yet
var successBG = const Color(0xFF00C363);
var warningBG = const Color(0xFFF85D59);
var warningDarkBG = const Color(0xFFD5534C);
var infoBG = const Color(0xFF009FF9);
var hoverBG = const Color(0xFFF2F2F2);

var primaryColor = const Color(0xFFF78A00);
var darkColor = const Color(0xFF5B5B5B);
var whiteColor = const Color(0xFFFFFFFF);
var greyColor = const Color(0xFFC3C3C3);
var shadowColor = const Color(0xFF808080);
var semidarkColor = const Color(0xFF212529); // Not used yet

var calendarItem = const Color(0xFF85DEF3); // Not used yet
var importantItem = const Color(0xFFFCC4C4); // Not used yet
var semiPrimary = const Color(0xFFFFF1DF);

// Border Radius
double roundedCircle = 100;
double roundedJumbo = 30;
double roundedXLG = 20;
double roundedLG = 18;
double roundedMD = 14;
double roundedSM = 10;
double roundedMini = 6; // Not used yet

// Font size
double textXJumbo = 32;
double textJumbo = 24;
double textXLG = 20;
double textLG = 18;
double textXMD = 14;
double textMD = 13;
double textSM = 12;
double textXSM = 11;

// Height & Width
double btnHeightMD = 55;

// Spacing
double spaceJumbo = 35;
double spaceXLG = 24;
double spaceLG = 20;
double spaceXMD = 16;
double spaceMD = 12;
double spaceSM = 10;
double spaceXSM = 8; // Not used yet
double spaceXXSM = 6; // Not used yet
double spaceMini = 4; // Not used yet

// Icon size
double iconJumbo = 40;
double iconXL = 32; //For floating add btn, ...
double iconLG = 24; //For floating add btn, ...
double iconMD = 18; //For link or file btn, ...
double iconSM = 15; //For content header ...

// Typography
final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(fontSize: textSM),
  displayMedium: GoogleFonts.poppins(fontSize: textSM),
  displaySmall: GoogleFonts.poppins(fontSize: textSM),
  headlineLarge: GoogleFonts.poppins(fontSize: textSM),
  headlineMedium: GoogleFonts.poppins(fontSize: textSM),
  headlineSmall: GoogleFonts.poppins(fontSize: textSM),
  titleLarge: GoogleFonts.poppins(fontSize: textSM),
  titleMedium: GoogleFonts.poppins(fontSize: textSM),
  titleSmall: GoogleFonts.poppins(fontSize: textSM),
  bodyLarge: GoogleFonts.poppins(fontSize: textSM),
  bodyMedium: GoogleFonts.poppins(fontSize: textSM),
  bodySmall: GoogleFonts.poppins(fontSize: textSM),
  labelLarge: GoogleFonts.poppins(fontSize: textSM),
  labelMedium: GoogleFonts.poppins(fontSize: textSM),
  labelSmall: GoogleFonts.poppins(fontSize: textSM),
  // headline1: GoogleFonts.poppins(),
  // headline2: GoogleFonts.poppins(),
  // headline3: GoogleFonts.poppins(),
  // headline4: GoogleFonts.poppins(),
  // headline5: GoogleFonts.poppins(),
  // headline6: GoogleFonts.poppins(),
  // subtitle1: GoogleFonts.poppins(),
  // subtitle2: GoogleFonts.poppins(),
  // bodyText1: GoogleFonts.poppins(),
  // bodyText2: GoogleFonts.poppins(),
  // caption: GoogleFonts.poppins(),
  // button: GoogleFonts.poppins(),
  // overline: GoogleFonts.poppins(),
);
