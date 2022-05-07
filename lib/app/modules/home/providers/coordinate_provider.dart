import 'package:get/get.dart';

import '../coordinate_model.dart';

class CoordinateProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Coordinate.fromJson(map);
      if (map is List)
        return map.map((item) => Coordinate.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Coordinate?> getCoordinate(int id) async {
    final response = await get('coordinate/$id');
    return response.body;
  }

  Future<Response<Coordinate>> postCoordinate(Coordinate coordinate) async =>
      await post('coordinate', coordinate);
  Future<Response> deleteCoordinate(int id) async =>
      await delete('coordinate/$id');
}
