import 'package:geolocator/geolocator.dart';

class Config {
  final String mapKey = "AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo";

  final String googleapis = "https://maps.googleapis.com/maps/api/";

  String findPlace(String placeName) {
    return googleapis +
        "place/autocomplete/json?input=$placeName&types=geocode&key=$mapKey&components=country:SA";
  }

  String coordinateFromAddress(Position position) {
    return googleapis +
        "geocode/json?latlng=${position.latitude},${position.longitude}=$mapKey";
  }
}
