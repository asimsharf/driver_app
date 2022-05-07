import 'dart:developer' as dev;

import 'package:driver/app/modules/search/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../home/controllers/home_controller.dart';
import '../directions_model.dart';
import '../place_predictions_model.dart';

class SearchController extends GetxController {
  var findHome = Get.find<HomeController>();

  TextEditingController txtPick = TextEditingController();
  var txtPickLat = 0.0.obs;
  var txtPickLng = 0.0.obs;

  TextEditingController txtDrop = TextEditingController();
  var txtDropLat = 0.0.obs;
  var txtDropLng = 0.0.obs;

  @override
  void onInit() {
    txtPick.text = findHome.formattedAddress.value;
    txtPickLat.value = findHome.lat.value;
    txtPickLng.value = findHome.lng.value;
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
      }).then((value) => findDirections());
    }
    update();
  }

  var routes = List<Routes>.empty(growable: true).obs;

  void findDirections() async {
    SearchProvider()
        .findDirections(LatLng(txtPickLat.value, txtPickLng.value),
            LatLng(txtDropLat.value, txtDropLng.value))
        .then((place) {
      dev.log(place.status!, name: 'find_directions');
      if (place.status == 'OK') {
        for (var e in place.routes!) {
          routes.add(e);
        }
        Map direction = {
          "legs": {
            "distance": {
              "text": routes.first.legs!.first.distance!.text,
              "value": routes.first.legs!.first.distance!.value
            },
            "duration": {
              "text": routes.first.legs!.first.duration!.text,
              "value": routes.first.legs!.first.duration!.value
            },
            "end_address": routes.first.legs!.first.endAddress,
            "end_location": {
              "lat": routes.first.legs!.first.endLocation!.lat,
              "lng": routes.first.legs!.first.endLocation!.lng,
            },
            "start_address": routes.first.legs!.first.startAddress,
            "start_location": {
              "lat": routes.first.legs!.first.startLocation!.lat,
              "lng": routes.first.legs!.first.startLocation!.lat
            },
          },
          "overview_polyline": {
            "points": routes.first.overviewPolyline!.points,
          }
        };
        dev.log("$direction", name: "direction");
      }
    });
    update();
  }
}
