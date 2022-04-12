import 'dart:developer' as dev;

import 'package:driver/app/modules/search/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController txtPick = TextEditingController();
  TextEditingController txtDrop = TextEditingController();

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      SearchProvider().findPlace(placeName).then((place) {
        dev.log(place, name: 'search_provider_place');
      });
    }
  }
}
