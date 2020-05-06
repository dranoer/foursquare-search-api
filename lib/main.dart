import 'package:flutter/material.dart';

import 'package:foursquare/ui/detail_screen.dart';
import 'package:foursquare/ui/map_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4Square',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      darkTheme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: MapScreen.id,
      routes: {
        MapScreen.id: (context) => MapScreen(),
        DetailScreen.id: (context) => DetailScreen()
      },
    );
  }
}
