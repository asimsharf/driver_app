import 'package:driver/app/modules/search/address_model.dart';
import 'package:get/get.dart';

import '../../../data/config.dart';
import '../place_predictions_model.dart';

class SearchProvider extends GetConnect {
  Future<PlacePredictions> findPlace(String placeName) async {
    try {
      final res = await get(Config().findPlace(placeName));

      if (res.status.hasError) {
        return Future.error(res.status);
      } else {
        return PlacePredictions.fromJson(res.body);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Address> findPlaceDetails(String placeID) async {
    try {
      final res = await get(Config().findPlaceDetails(placeID));

      if (res.status.hasError) {
        return Future.error(res.status);
      } else {
        return Address.fromJson(res.body);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
