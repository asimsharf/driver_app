import 'dart:async';
import 'dart:developer' as dev;

import 'package:driver/app/modules/home/providers/home_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  final Completer<GoogleMapController> completerGmc = Completer();

  late GoogleMapController googleMc;

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(24.6812168, 46.7380791),
    zoom: 14.4746,
  );

  late Position currentPosition;

  var geoLocator = Geolocator();

  double bottomPadding = 0;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );
    googleMc.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    HomeProvider().coordinateFromAddress(position).then((address) {
      dev.log(address, name: 'home_provider_address');
    });
  }
}
