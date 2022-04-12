import 'package:get/get.dart';

import '../../../data/config.dart';

class SearchProvider extends GetConnect {
  Future<String> findPlace(String placeName) async {
    try {
      final res = await get(Config().findPlace(placeName));

      if (res.status.hasError) {
        return Future.error(res.status);
      } else {
        return res.body;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
