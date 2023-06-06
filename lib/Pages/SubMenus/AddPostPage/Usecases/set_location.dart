import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_fik/Components/Forms/input.dart';
import 'package:mi_fik/Components/Typography/title.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetLocation extends StatefulWidget {
  SetLocation({Key key, this.locDetailCtrl}) : super(key: key);
  TextEditingController locDetailCtrl;

  @override
  _SetLocation createState() => _SetLocation();
}

class _SetLocation extends State<SetLocation>
    with SingleTickerProviderStateMixin {
  //Initial variable.
  //_MapsPageState(passIdFakses);
  GoogleMapController _googleMapController;
  Marker _coordinate;
  bool servicestatus = false;
  bool haspermission = false;
  LocationPermission permission;
  Position position;
  double mylong = 0, mylat = 0;
  StreamSubscription<Position> positionStream;
  Uint8List bytes;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  //Get my location.
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Alert", "Location permissions are permently denied",
              backgroundColor: whitebg);
        } else if (permission == LocationPermission.deniedForever) {
          if (permission == LocationPermission.denied) {
            Get.snackbar("Alert", "Location permissions are permently denied",
                backgroundColor: whitebg);
          }
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {});

        getLocation();
      }
    } else {
      if (permission == LocationPermission.denied) {
        Get.snackbar(
            "Alert", "GPS Service is not enabled, turn on GPS location");
      }
    }

    setState(() {});
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    mylong = position.longitude;
    mylat = position.latitude;

    // setState(() {
    //   //refresh UI
    // });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      mylong = position.longitude;
      mylat = position.latitude;

      setState(() {});
    });

    String imgurl =
        "https://leonardhors.site/public/assets/img/87409344219_PAS_FOTO_2.jpg";
    bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = MediaQuery.of(context).size.height;

    //Get location name and coordinate from json.
    // final jsonLoc = json.decode(widget.passLocation.toString());
    // var location = jsonLoc[0]['detail'];
    // var coordinate = jsonLoc[1]['detail'].split(', ');
    // double lat = double.parse(coordinate[0]);
    // double lng = double.parse(coordinate[1]);

    //Maps starting point.
    final _initialCameraPosition = CameraPosition(
      target: LatLng(mylat, mylong),
      zoom: 14,
    );

    getButtonText(coor, detail) {
      if (coor == null && detail.isEmpty) {
        return "Set My Location";
      } else if ((coor == null && detail.isNotEmpty) ||
          (coor != null && detail.isNotEmpty)) {
        return detail.toString();
      } else if (coor != null && detail.isEmpty) {
        var coordinate = coor.split(',');
        double lat = double.parse(coordinate[0]);
        double lng = double.parse(coordinate[1]);

        return "${lat.toStringAsFixed(3)}, ${lng.toStringAsFixed(3)}";
      }
    }

    return TextButton.icon(
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  insetPadding: EdgeInsets.all(paddingSM),
                  contentPadding: EdgeInsets.all(paddingMD),
                  content: SizedBox(
                    height: fullHeight *
                        0.6, //Pop up height based on fullwidth (Square maps).
                    width: fullWidth,
                    child: Column(children: [
                      Flexible(
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: (controller) =>
                              _googleMapController = controller,
                          markers: {
                            if (_coordinate != null) _coordinate,
                          },
                          onTap: ((LatLng pos) async {
                            if (_coordinate == null || _coordinate != null) {
                              setState(() {
                                _coordinate = Marker(
                                  markerId: const MarkerId('origin'),
                                  infoWindow: const InfoWindow(
                                      title: 'Selected Location'),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueOrange),
                                  position: pos,
                                );
                                locCoordinateCtrl =
                                    "${pos.latitude}, ${pos.longitude}";
                              });
                            }
                          }),
                        ),
                      ),
                      SizedBox(height: paddingMD),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: getSubTitleMedium(
                              "Location Name", blackbg, TextAlign.start)),
                      getInputText(75, widget.locDetailCtrl, false)
                    ]),
                  ));
            });
          }).then((_) => setState(() {})), //Check this again !!!!
      icon: Icon(Icons.location_on_outlined, size: 22, color: semiblackbg),
      label: Text(getButtonText(locCoordinateCtrl, widget.locDetailCtrl.text),
          style: TextStyle(
              fontSize: textMD,
              color: semiblackbg,
              fontWeight: FontWeight.w400)),
    );
  }

  //Check this!!!!
  @override
  void dispose() {
    //_googleMapController.dispose();
    super.dispose();
  }

  // void _addMarker(LatLng pos) async {

  // }
}
