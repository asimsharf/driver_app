import 'package:driver/app/data/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeProvider extends GetConnect {
  Future<String> coordinateFromAddress(Position position) async {
    try {
      final res = await get(Config().coordinateFromAddress(position));

      if (res.status.hasError) {
        return Future.error(res.status);
      } else {
        return res.body['results'][0]['formatted_address'];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
