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

class HomeController extends GetxController with GetTickerProviderStateMixin {
  RxBool isLoading = true.obs;

  final Duration duration = const Duration(milliseconds: 160);

  late AnimationController animationController;

  @override
  void onInit() {
    getLocation();
    super.onInit();
    animationController = AnimationController(vsync: this, duration: duration);
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

  RxDouble bottomPadding = 0.0.obs;

  set setBottomPadding(double padding) {
    bottomPadding.value = padding;
  }

  var formattedAddress = "".obs;
  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;

  locatePosition() async {
    try {
      isLoading(true);
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
    } catch (e, s) {
      dev.log("$e", name: "home_controller_catch_exception_e");
      dev.log("$s", name: "home_controller_catch_exception_s");
    } finally {
      isLoading(false);
    }
    update();
  }

  RxList<poly.Routes> routes = List<poly.Routes>.empty(growable: true).obs;

  RxList<LatLng> pLineCoordinates = List<LatLng>.empty(growable: true).obs;

  RxList<Marker> markersSet = List<Marker>.empty(growable: true).obs;

  RxList<Polyline> polyLineSet = List<Polyline>.empty(growable: true).obs;

  RxList<Circle> circlesSet = List<Circle>.empty(growable: true).obs;

  RxString distanceText = "".obs;
  RxInt distanceValue = 0.obs;
  RxString durationText = "".obs;
  RxInt durationValue = 0.obs;

  findDirections(pLat, pLng, dLat, dLng) async {
    try {
      isLoading(true);
      HomeProvider()
          .findDirections(
        LatLng(pLat.value, pLng.value),
        LatLng(dLat.value, dLng.value),
      )
          .then((place) {
        routes.clear();
        if (place.status == 'OK') {
          for (var e in place.routes!) {
            routes.add(e);
          }

          distanceText.value = routes.first.legs!.first.distance!.text!;
          distanceValue.value = routes.first.legs!.first.distance!.value!;
          durationText.value = routes.first.legs!.first.duration!.text!;
          durationValue.value = routes.first.legs!.first.duration!.value!;

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
            color: const Color(0xFFBF202E),
            polylineId: const PolylineId('POLYLINEID'),
            jointType: JointType.round,
            points: pLineCoordinates,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            geodesic: true,
          );

          polyLineSet.add(polyline);

          LatLngBounds latLngBounds;

          var pickUpLatLng = LatLng(pLat.value, pLng.value);
          var dropOffLatLng = LatLng(dLat.value, dLng.value);

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

          Marker pickUpLocMarker = Marker(
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: routes.first.legs!.first.startAddress,
              snippet: "موقع الإقلاع",
            ),
            position: pickUpLatLng,
            markerId: const MarkerId("PICKUPID"),
          );

          Marker dropOffUpLocMarker = Marker(
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: routes.first.legs!.first.endAddress,
              snippet: "موقع الوصول",
            ),
            position: dropOffLatLng,
            markerId: const MarkerId("DROOPOFFID"),
          );

          markersSet.add(pickUpLocMarker);
          markersSet.add(dropOffUpLocMarker);

          Circle pickUpLocCircle = Circle(
            fillColor: Colors.black,
            center: pickUpLatLng,
            radius: 12,
            strokeWidth: 4,
            strokeColor: Colors.black,
            circleId: const CircleId("PICKUPID"),
          );

          Circle dropOffUpLocCircle = Circle(
            fillColor: const Color(0xFFBF202E),
            center: dropOffLatLng,
            radius: 12,
            strokeWidth: 4,
            strokeColor: const Color(0xFFBF202E),
            circleId: const CircleId("DROOPOFID"),
          );

          circlesSet.add(pickUpLocCircle);
          circlesSet.add(dropOffUpLocCircle);
          displayRideContainer();
          calculateFares();
          Get.back();
        }
      });
    } catch (e, s) {
      dev.log("$e", name: "home_controller_catch_exception_e");
      dev.log("$s", name: "home_controller_catch_exception_s");
    } finally {
      isLoading(false);
    }
    update();
  }

  RxDouble rideDetailsContainer = 0.0.obs;
  RxDouble searchContainerHeight = 350.0.obs;

  void displayRideContainer() async {
    searchContainerHeight.value = 0;
    rideDetailsContainer.value = 230;
    bottomPadding.value = 0;
    update();
  }

  RxDouble totalFareAmount = 0.0.obs;
  calculateFares() {
    double timeTraveledFare = (durationValue / 60) * 0.20;
    double distanceTraveledFare = (distanceValue / 1000) * 0.20;
    double totalTraveledFare = timeTraveledFare + distanceTraveledFare;
    totalFareAmount.value = totalTraveledFare * 3.75;
    update();
  }
}
