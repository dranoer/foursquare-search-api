import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  String _authParameter;

  API.userless(String clientId, String clientSecret) {
    _authParameter = '&client_id=$clientId&client_secret=$clientSecret';
  }

  // Performs a GET request to Foursquare API.
  Future<Map<String, dynamic>> get(String endpoint,
      [String parameters = '']) async {
    final response = await http
        .get(
            'https://api.foursquare.com/v2/$endpoint?v=20200301$_authParameter$parameters')
        .timeout(Duration(seconds: 5));
    if (response.statusCode == 200) {
      return json.decode(response.body)['response'];
    } else {
      return null;
    }
  }
}
