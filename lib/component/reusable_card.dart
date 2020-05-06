import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({this.controller, this.name, this.lat, this.lng});

  final Completer<GoogleMapController> controller;
  final String name;
  final String lat;
  final String lng;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final GoogleMapController cont = await controller.future;
        cont.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(double.parse(lat), double.parse(lng)),
          zoom: 22,
          tilt: 50.0,
          bearing: 45.0,
        )));
      },
      child: Container(
        child: FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey.shade600,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: detailsContainer(name),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

Widget detailsContainer(String name) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
            child: Text(
          name,
          style: TextStyle(
              color: Colors.indigo,
              fontSize: 12.0,
              fontWeight: FontWeight.bold),
        )),
      ),
      Container(
          child: Text(
        name,
        style: TextStyle(
            color: Colors.black54, fontSize: 10.0, fontWeight: FontWeight.bold),
      )),
    ],
  );
}
