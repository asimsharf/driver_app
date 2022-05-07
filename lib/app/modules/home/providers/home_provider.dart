import 'package:driver/app/data/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

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
}
