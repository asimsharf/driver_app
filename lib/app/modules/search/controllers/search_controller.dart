import 'dart:developer' as dev;

import 'package:driver/app/modules/search/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../place_predictions_model.dart';

class SearchController extends GetxController {
  TextEditingController txtPick = TextEditingController();
  var txtPickLat = 0.0.obs;
  var txtPickLng = 0.0.obs;

  TextEditingController txtDrop = TextEditingController();
  var txtDropLat = 0.0.obs;
  var txtDropLng = 0.0.obs;

  @override
  void onInit() {
    txtPick.text = Get.find<HomeController>().formattedAddress.value;
    txtPickLat.value = Get.find<HomeController>().lat.value;
    txtPickLng.value = Get.find<HomeController>().lng.value;
    super.onInit();
  }

  var placePredictionsList = List<Predictions>.empty(growable: true).obs;

  void findPlace(String placeName) async {
    dev.log(placeName, name: 'Place_Name');
    if (placeName.length > 1) {
      SearchProvider().findPlace(placeName).then((place) {
        dev.log(place.status!, name: 'find_place');
        if (place.status == 'OK') {
          placePredictionsList.clear();
          for (var e in place.predictions!) {
            placePredictionsList.add(e);
          }
        }
      });
    }
    update();
  }

  void findPlaceDetails(String placeID) async {
    if (placeID.length > 1) {
      SearchProvider().findPlaceDetails(placeID).then((place) {
        dev.log(place.status!, name: 'search_find_place_details');
        if (place.status == 'OK') {
          txtDrop.text = place.result!.formattedAddress!;
          txtDropLat.value = place.result!.geometry!.location!.lat!;
          txtDropLng.value = place.result!.geometry!.location!.lng!;
        }
      }).then(
        (value) => Get.find<HomeController>().findDirections(
          txtPickLat,
          txtPickLng,
          txtDropLat,
          txtDropLng,
        ),
      );
    }
    update();
  }
}
