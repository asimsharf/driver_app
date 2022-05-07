import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String mapKey = "AIzaSyD6X2gFvIjTvzfKJon66z9Sk8vqXv8NMzw";

  final String googleapis = "https://maps.googleapis.com/maps/api";

  //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=qu&types=geocode&key=AIzaSyD6X2gFvIjTvzfKJon66z9Sk8vqXv8NMzw&components=country:SA&language=ar
  String findPlace(String placeName) {
    return googleapis +
        "/place/autocomplete/json?input=$placeName&types=geocode&key=$mapKey&components=country:SA&language=ar";
  }

  //https://maps.googleapis.com/maps/api/geocode/json?latlng=34.1358593,-117.922066&key=AIzaSyD6X2gFvIjTvzfKJon66z9Sk8vqXv8NMzw&components=country:SA&language=ar
  String coordinateFromAddress(Position position) {
    return googleapis +
        "/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey&components=country:SA&language=ar";
  }

  //https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJzzgyJU--woARcZqceSdQ3dM&key=AIzaSyD6X2gFvIjTvzfKJon66z9Sk8vqXv8NMzw&components=country:SA&language=ar
  String findPlaceDetails(String placeID) {
    return googleapis +
        "/place/details/json?place_id=$placeID&key=$mapKey&components=country:SA&language=ar";
  }

  //https://maps.googleapis.com/maps/api/directions/json?origin=23.885942,45.079162&destination=21.5202768,39.2308587&key=AIzaSyD6X2gFvIjTvzfKJon66z9Sk8vqXv8NMzw&components=country:SA&language=ar
  String findDirections(LatLng origin, LatLng destination) {
    return googleapis +
        "/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey&components=country:SA&language=ar";
  }
}
