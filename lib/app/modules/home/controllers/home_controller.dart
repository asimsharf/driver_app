import 'dart:async';
import 'dart:developer' as dev;

import 'package:driver/app/modules/home/providers/home_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class HomeController extends GetxController {
  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  location.Location locations = location.Location();
  late location.LocationData _locationData;
  getLocation() async {
    locations.enableBackgroundMode(enable: true);
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;

    _serviceEnabled = await locations.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locations.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await locations.hasPermission();

    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await locations.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    locations.onLocationChanged.listen((location.LocationData currentLocation) {
      dev.log(currentLocation.toString(), name: "current_location");
      kGooglePlex = CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 14.4746,
      );
    });

    _locationData = await locations.getLocation();

    dev.log(_locationData.toString(), name: "_location_data");
    update();
  }

  Completer<GoogleMapController> completerGmc = Completer();

  late GoogleMapController googleMc;

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.785834, -122.406417),
    zoom: 14.4746,
  );

  late Position currentPosition;

  var geoLocator = Geolocator();

  double bottomPadding = 0;

  set setBottomPadding(double padding) {
    bottomPadding = padding;
  }

  var formattedAddress = "".obs;
  var lat = 0.0.obs;
  var lng = 0.0.obs;

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
      dev.log(address.status!, name: 'home_address');
      if (address.status == 'OK') {
        formattedAddress.value = address.results![0].formattedAddress!;
        lat.value = address.results![0].geometry!.location!.lat!;
        lng.value = address.results![0].geometry!.location!.lng!;
      }
    });
  }
}
