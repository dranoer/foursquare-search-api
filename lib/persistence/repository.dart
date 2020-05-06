import 'package:foursquare/model/venue.dart';
import 'package:foursquare/persistence/api.dart';

class Repository {
  API api = API.userless(
    'T3H15FLZLQZWSMGCX3YRXP42SFQEH5CWE4XP1FRV3WWS0O1K',
    '225DDZRTWQZ3IZZPXOA4CGSYINTKEQMLGJMRH1M5QIAJAXTO',
  );

  // List of Venues
  Future<List<Venue>> searchVenues(API api, double latitude, double longitude,
      [String parameters = '']) async {
    List items = (await api.get(
        'venues/search', '&ll=$latitude,$longitude$parameters'))['venues'];
    return items.map((item) => Venue.fromJsonLimited(item)).toList();
  }

  // Specific Venue
  Future<Venue> get(API api, String venueId) async {
    return Venue.fromJson((await api.get('venues/$venueId'))['venue']);
  }
}
