import 'package:driver/app/data/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../search/directions_model.dart';
import '../coordinate_model.dart';

class HomeProvider extends GetConnect {
  Future<Coordinate> coordinateFromAddress(Position position) async {
    try {
      final res = await get(Config().coordinateFromAddress(position));

      if (res.status.hasError) {
        return Future.error(res.status);
      } else {
        return Coordinate.fromJson(res.body);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Directions> findDirections(LatLng origin, LatLng destination) async {
    try {
      final res = await get(Config().findDirections(origin, destination));
      if (res.status.hasError) {
        return Future.error(res.status);
      } else {
        return Directions.fromJson(res.body);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
