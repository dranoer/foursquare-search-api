import 'package:rxdart/rxdart.dart';

import 'package:foursquare/bloc/base_bloc.dart';
import 'package:foursquare/model/venue.dart';
import 'package:foursquare/persistence/repository.dart';

class RequestBloc implements BaseBloc {
  Repository _repository = Repository();

  // Subject
  final _venuesFetcher = PublishSubject<List<Venue>>();
  final _venueFetcher = PublishSubject<Venue>();

  // Observable
  Observable<List<Venue>> get venues => _venuesFetcher.stream;
  Observable<Venue> get venue => _venueFetcher.stream;

  fetchVenues(double lat, double lng) async {
    List<Venue> response =
        await _repository.searchVenues(_repository.api, lat, lng);
    _venuesFetcher.sink.add(response);
  }

  fetchVenue(String venueId) async {
    Venue response = await _repository.get(_repository.api, venueId);
    _venueFetcher.sink.add(response);
  }

  @override
  void dispose() {
    _venuesFetcher.close();
    _venueFetcher.close();
  }
}
