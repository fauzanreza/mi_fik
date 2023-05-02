import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationButton extends StatefulWidget {
  LocationButton({Key key, this.passLocation, this.passSlugName})
      : super(key: key);
  var passLocation;
  final String passSlugName;

  @override
  _LocationButton createState() => _LocationButton();
}

class _LocationButton extends State<LocationButton>
    with SingleTickerProviderStateMixin {
  //Initial variable.
  //_MapsPageState(passIdFakses);
  GoogleMapController googleMapController;
  Marker _origin;
  Marker _destination;
  bool servicestatus = false;
  bool haspermission = false;
  LocationPermission permission;
  Position position;
  String my_long = "", my_lat = "";
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
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
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
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {});
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    my_long = position.longitude.toString();
    my_lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      my_long = position.longitude.toString();
      my_lat = position.latitude.toString();

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

    //Get location name and coordinate from json.
    var coordinate = widget.passLocation[1]['detail'].split(', ');
    double lat = double.parse(coordinate[0]);
    double lng = double.parse(coordinate[1]);

    //Maps starting point.
    final initialCameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14,
    );

    return TextButton.icon(
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              insetPadding: EdgeInsets.all(paddingSM),
              contentPadding: EdgeInsets.all(paddingMD),
              content: SizedBox(
                height:
                    fullWidth, //Pop up height based on fullwidth (Square maps).
                width: fullWidth,
                child: Column(children: [
                  Flexible(
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (controller) =>
                          googleMapController = controller,
                      markers: {
                        if (_origin != null) _origin,
                        if (_destination != null) _destination,
                        Marker(
                          markerId: MarkerId(widget.passSlugName),
                          infoWindow: InfoWindow(
                              title: getLocationName(widget.passLocation)),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueOrange),
                          position: LatLng(lat, lng),
                        ),
                        Marker(
                          markerId: const MarkerId("0"),
                          infoWindow: const InfoWindow(title: "You"),

                          // icon: BitmapDescriptor.defaultMarkerWithHue(
                          //     BitmapDescriptor.hueRed),
                          icon: BitmapDescriptor.fromBytes(bytes),
                          position: LatLng(
                              double.parse(my_lat), double.parse(my_long)),
                        )
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(top: paddingMD),
                      width: fullWidth,
                      height: btnHeightMD - 10,
                      child: ElevatedButton(
                        onPressed: () async {
                          //Navigate through google maps w/ direction.
                          String googleUrl =
                              //'https://www.google.com/maps/dir/Current+Location/?api=1&query=${lat},${lng}';
                              'https://www.google.com/maps/dir/Current+Location/$lat,$lng';
                          if (await canLaunch(googleUrl)) {
                            await launch(googleUrl);
                          } else {
                            throw 'Could not open the map.';
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(primaryColor),
                        ),
                        child: const Text('Navigate'),
                      ))
                ]),
              ))),
      icon: Icon(Icons.location_on_outlined, size: 22, color: primaryColor),
      label: Text(getLocationName(widget.passLocation),
          style: TextStyle(fontSize: textMD, color: primaryColor)),
    );
  }

  //Check this!!!!
  @override
  void dispose() {
    //_googleMapController.dispose();
    super.dispose();
  }
}
