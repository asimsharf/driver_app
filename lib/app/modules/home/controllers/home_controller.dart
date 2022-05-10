import 'dart:async';
import 'dart:developer' as dev;

import 'package:driver/app/modules/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

import '../../search/directions_model.dart' as poly;

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
    target: LatLng(24.8208356, 46.7479246),
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
    update();
  }

  var routes = List<poly.Routes>.empty(growable: true).obs;

  var pLineCoordinates = List<LatLng>.empty(growable: true).obs;

  // var markersSet = List<Marker>.empty(growable: true).obs;

  Set<Marker> markersSet = {};

  // var polyLineSet = List<Polyline>.empty(growable: true).obs;

  Set<Polyline> polyLineSet = {};

  var circlesSet = List<Circle>.empty(growable: true).obs;

  void findDirections(txtPickLat, txtPickLng, txtDropLat, txtDropLng) async {
    HomeProvider()
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

        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> decodedResult = polylinePoints.decodePolyline(
          routes.first.overviewPolyline!.points!,
        );

        pLineCoordinates.clear();

        if (decodedResult.isNotEmpty) {
          for (var p in decodedResult) {
            pLineCoordinates.add(LatLng(p.latitude, p.longitude));
          }
        }

        polyLineSet.clear();

        Polyline polyline = Polyline(
          color: Colors.red,
          polylineId: const PolylineId('PolylineID'),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );

        polyLineSet.add(polyline);

        LatLngBounds latLngBounds;

        var pickUpLatLng = LatLng(txtPickLat.value, txtPickLng.value);
        var dropOffLatLng = LatLng(txtDropLat.value, txtDropLng.value);

        if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
            pickUpLatLng.longitude > dropOffLatLng.longitude) {
          latLngBounds = LatLngBounds(
            southwest: dropOffLatLng,
            northeast: pickUpLatLng,
          );
        } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
          latLngBounds = LatLngBounds(
            southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
            northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          );
        } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
          latLngBounds = LatLngBounds(
            southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
            northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          );
        } else {
          latLngBounds = LatLngBounds(
            southwest: pickUpLatLng,
            northeast: dropOffLatLng,
          );
        }
        googleMc.animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds, 70),
        );
        Get.back();
      }
    });
    update();
  }
}
