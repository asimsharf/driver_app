import 'dart:developer' as dev;

import 'package:driver/app/modules/search/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../place_predictions_model.dart';

class SearchController extends GetxController {
  TextEditingController txtPick = TextEditingController();
  RxDouble pLat = 0.0.obs;
  RxDouble pLng = 0.0.obs;

  TextEditingController txtDrop = TextEditingController();
  RxDouble dLat = 0.0.obs;
  RxDouble dLng = 0.0.obs;

  @override
  void onInit() {
    txtPick.text = Get.find<HomeController>().formattedAddress.value;
    pLat.value = Get.find<HomeController>().lat.value;
    pLng.value = Get.find<HomeController>().lng.value;
    super.onInit();
  }

  var placePredictionsList = List<Predictions>.empty(growable: true).obs;

  void findPlace(String placeName) async {
    dev.log(placeName, name: 'find_place_place_name');
    if (placeName.length > 1) {
      SearchProvider().findPlace(placeName).then((place) {
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
        if (place.status == 'OK') {
          txtDrop.text = place.result!.formattedAddress!;
          dLat.value = place.result!.geometry!.location!.lat!;
          dLng.value = place.result!.geometry!.location!.lng!;
        }
      }).then(
        (value) {
          Get.find<HomeController>().findDirections(
            pLat,
            pLng,
            dLat,
            dLng,
          );
        },
      );
    }
    update();
  }
}
