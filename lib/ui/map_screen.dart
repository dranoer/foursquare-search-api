import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:foursquare/bloc/geo_position_bloc.dart';
import 'package:foursquare/bloc/map_bloc.dart';
import 'package:foursquare/bloc/request_bloc.dart';
import 'package:foursquare/component/reusable_card.dart';
import 'package:foursquare/model/venue.dart';
import 'package:foursquare/constants.dart';

class MapScreen extends StatefulWidget {
  static const String id = "home_screen";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _geoPositionBloc = GeoPositionBloc();
  final _mapBloc = MapBloc();
  final _requestBloc = RequestBloc();

  // Google maps
  Completer<GoogleMapController> _controller = Completer();

  // Position
  double _originLat;
  double _originLng;
  CameraPosition newPosition;

  @override
  void initState() {
    super.initState();
    _geoPositionBloc.init();
  }

  @override
  void dispose() {
    _geoPositionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: _geoPositionBloc.position,
      builder: (context, positionSnapShot) {
        return StreamBuilder(
          stream: _requestBloc.venues,
          builder: (context, AsyncSnapshot<List<Venue>> venuesSnapshot) {
            if (positionSnapShot.hasData) {
              _originLat = positionSnapShot.data.latitude;
              _originLng = positionSnapShot.data.longitude;

              if (_originLat != null && _originLng != null) {
                // Set custom marker on current location
                _mapBloc.setOriginMarkers(_originLat, _originLng);
                _mapBloc.setMyPin();

                // ToDo: This method should call before this block.
                // Fetch list of venues base on current location
                _requestBloc.fetchVenues(positionSnapShot.data.latitude,
                    positionSnapShot.data.longitude);
                // check if data has been loaded, then set markers on all of the fetched items
                if (venuesSnapshot.hasData) {
                  _setVenuesMarkers(venuesSnapshot.data);
                }

                return _setMap();
              } else {
                return _setError("Failed to get position");
              }
            } else if (positionSnapShot.hasError) {
              return _setError(positionSnapShot.error);
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      },
    );
  }

  Widget _setMap() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildGoogleMap(),
          Positioned(
            top: 50.0,
            child: _buildSearchButton(),
          ),
          _buildContainer(),
        ],
      ),
    );
  }

  // Map
  Widget _buildGoogleMap() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<Map<MarkerId, Marker>>(
          initialData: <MarkerId, Marker>{},
          stream: _mapBloc.markerList,
          builder: (BuildContext context,
              AsyncSnapshot<Map<MarkerId, Marker>> mapSnapshot) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_originLat, _originLng),
                zoom: 18,
              ),
              onMapCreated: (controller) => _controller.complete(controller),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: Set<Marker>.of(mapSnapshot.data.isNotEmpty
                  ? mapSnapshot.data.values
                  : <Marker>[]),
              onCameraMove: (cameraPosition) {
                setState(() {
                  newPosition = cameraPosition;
                });
              },
            );
          }),
    );
  }

  // Search
  Widget _buildSearchButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: Colors.indigo.shade800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: FlatButton(
        child: Text(Strings.kSearch, style: kSearchTS),
        onPressed: () {
          _mapBloc.removeMarkers();
          setState(() {
            return StreamBuilder<List<Venue>>(
              initialData: _requestBloc.fetchVenues(
                  newPosition.target.latitude, newPosition.target.longitude),
              stream: _requestBloc.venues,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Venue>> venuesSnapshot) {
                if (venuesSnapshot.hasData) {
                  _setVenuesMarkers(venuesSnapshot.data);
                  return _setMap();
                } else if (venuesSnapshot.hasError) {
                  return _setError(venuesSnapshot.error);
                } else {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          });
        },
      ),
    );
  }

  // Cards
  Widget _buildContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: _requestBloc.venues,
          builder: (BuildContext context,
              AsyncSnapshot<List<Venue>> venuesSnapshot) {
            if (venuesSnapshot.hasData) {
              return Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 150.0,
                  child: ListView.builder(
                    itemCount: venuesSnapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ReusableCard(
                          controller: _controller,
                          name: venuesSnapshot.data[index].name,
                          lat: venuesSnapshot.data[index].locationLat,
                          lng: venuesSnapshot.data[index].locationLng,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          }),
    );
  }

  void _setVenuesMarkers(List<Venue> venuesSnapshot) {
    for (int i = 0; i <= venuesSnapshot.length - 1; i++) {
      _mapBloc.setVenueMarkers(
          venuesSnapshot[i].name,
          double.parse(venuesSnapshot[i].locationLat),
          double.parse(venuesSnapshot[i].locationLng),
          venuesSnapshot[i].venueId,
          context);
    }
    _mapBloc.setCustomMapPin();
  }

  Widget _setError(String text) {
    return Scaffold(
      body: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }
}
