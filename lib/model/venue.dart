class Venue {
  Venue({
    this.venueId,
    this.name,
    this.locationAddress,
    this.locationLat,
    this.locationLng,
    this.location,
    this.city,
    this.state,
    this.cc,
    this.category,
    this.rating,
//      this.photoPrefix,
//      this.photoSuffix
  });

  final String venueId;
  final String name;
  final String locationAddress;
  final String locationLat;
  final String locationLng;
  String location;
  String city;
  String state;
  String cc;
  String category;
  double rating;
//  String photoPrefix;
//  String photoSuffix;

  // Constructor for requests with less params (some of them are empty which causes null response.
  // ToDo: handle this issue in default constructor instead of using 02 constructors.
  Venue.limited(
      {this.venueId,
      this.name,
      this.locationAddress,
      this.locationLat,
      this.locationLng});

  @override
  String toString() {
    return '$venueId, $name, $location, $locationAddress, $locationLat, $locationLng, $category, $rating';
  }

  bool operator ==(otherVenue) =>
      otherVenue is Venue && venueId == otherVenue.venueId;

  int get hashCode => venueId.hashCode;

  factory Venue.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Venue(
        venueId: json['id'],
        name: json['name'],
        location:
            '${json['location']['city']}, ${json['location']['state']}, ${json['location']['cc']}' ??
                '',
        city: json['city'],
        state: json['state'],
        cc: json['cc'],
        category: json['categories'][0]['name'] ?? '',
        rating: json['rating'],
//          photoPrefix: json['bestPhoto']['prefix'],
//          photoSuffix: json['bestPhoto']['suffix']
      );
    } else {
      return null;
    }
  }

  // Less parameters
  factory Venue.fromJsonLimited(Map<String, dynamic> json) {
    if (json != null) {
      return Venue.limited(
          venueId: json['id'],
          name: json['name'],
          locationAddress: '${json['location']['address']}',
          locationLat: '${json['location']['lat']}',
          locationLng: '${json['location']['lng']}');
    } else {
      return null;
    }
  }
}
