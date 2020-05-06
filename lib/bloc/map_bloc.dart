import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foursquare/bloc/base_bloc.dart';
import 'package:foursquare/model/argument.dart';
import 'package:foursquare/ui/detail_screen.dart';

class MapBloc implements BaseBloc {
  Map<MarkerId, Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor myPinLocationIcon;

  // Subjects or StreamControllers
  final _markerList = BehaviorSubject<Map<MarkerId, Marker>>();

  // Observable
  Observable<Map<MarkerId, Marker>> get markerList => _markerList.stream;

  // Set marker on current position
  void setOriginMarkers(double lat, double lng) {
    var markerId = MarkerId("Current location");
    var marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: myPinLocationIcon,
      infoWindow: InfoWindow(
        title: "Current location",
        snippet: "This is your current location.",
      ),
    );

    _markers[markerId] = marker;
    _markerList.sink.add(_markers);
  }

  // Set marker on a list of venues
  void setVenueMarkers(String name, double lat, double lng, String venueId,
      BuildContext context) {
    var markerId = MarkerId(name);
    var marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        icon: pinLocationIcon,
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.id,
              arguments: ScreenArgument(venueId: venueId));
        });

    _markers[markerId] = marker;
    _markerList.sink.add(_markers);
  }

  void removeMarkers() {
    _markers.clear();
    _markerList.sink.add(_markers);
  }

  void setMyPin() async {
    myPinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/current_position_marker.png');
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/blue_marker.png');
  }

  @override
  void dispose() {
    _markerList.close();
  }
}
