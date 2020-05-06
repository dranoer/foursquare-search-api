import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foursquare/bloc/base_bloc.dart';

class GeoPositionBloc implements BaseBloc {
  final geoLocator = Geolocator();
  var locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  // Subjects or StreamControllers
  final _position = BehaviorSubject<Position>();

  // Observable
  Observable<Position> get position => _position.stream;

  void init() {
    geoLocator.getPositionStream(locationOptions).listen((position) {
      print("${position.latitude}, ${position.longitude}");
      _position.sink.add(position);
    });
  }

  @override
  void dispose() {
    _position.close();
  }
}
