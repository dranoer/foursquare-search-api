import 'package:flutter/material.dart';

/* COLOR */
const kLightGrey = Color(0xFFEEEEEE);
const kDarkGrey = Color(0xFF212121);

/* TEXT STYLE */
// Map screen
const kSearchTS = TextStyle(color: Colors.white, fontSize: 18.0);

// Detail screen
const kAppbarTS =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w100, letterSpacing: 4.0);
const kAppbarTitleTS = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
const kInfoTS = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'Montserrat');
const kInfoDataTS = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Montserrat');
const kDescriptionTS = TextStyle(
    fontSize: 14,
    wordSpacing: 1.0,
    height: 1.4,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat');

/* STRING */
class Strings {
  // Map screen
  static const String kSearch = 'Search this aria';

  // Detail screen
  static const String kError = 'An error occurred.';
  static const String kAppbarText = 'DETAIL';
  static const String kName = 'Name: ';
  static const String kCategory = 'Category: ';
  static const String kDescription = 'Description:\n';
  static const String kDescriptionText =
      'This is a fake property: With nearly 200 bottle selections, Maison Premiere has a larger wine list than many restaurants. Guests can score the type of geek-out-able wines that fill the dreams of sommeliers around town.';
}
